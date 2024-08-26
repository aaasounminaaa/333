data "aws_region" "day3-cw_current" {}

resource "aws_iam_role" "day3-lambda" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

data "archive_file" "day3-lambda" {
  type        = "zip"
  source_file = "./app/lambda_function.py"
  output_path = "./app/lambda_function_payload.zip"
}

resource "aws_lambda_function" "day3-lambda" {
    function_name = "ec2-count-function"
    handler = "lambda_function.lambda_handler"
    filename = "./app/lambda_function_payload.zip"
    role = aws_iam_role.day3-lambda.arn
    timeout = "15"
    source_code_hash = data.archive_file.day3-lambda.output_base64sha256
    runtime = "python3.12"
    publish = true
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "example_target" {
  arn  = aws_lambda_function.day3-lambda.arn  # Point to the Lambda function ARN
  rule = aws_cloudwatch_event_rule.event_rule.name
}

resource "aws_lambda_permission" "kps_lambda_event_prod_daily_report" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.day3-lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn  # Point to the Event Rule ARN
}