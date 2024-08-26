resource "aws_kinesis_stream" "kds" {
  name = "CloudFront-DataStream"
  shard_count = "4"
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED" # PROVISIONED or ON_DEMAND
  }

  tags = {
    Environment = "CloudFront-DataStream"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "kinesis-firhost-RealTime"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.bucket.arn

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
        }
      }
    }
  }
}



resource "aws_s3_bucket" "bucket" {
  bucket = "day3-cf-log-bucket-${random_string.bucket_random.result}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "day3_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "archive_file" "seoul-lambda" {
  type        = "zip"
  source_file = "./real_time/lambda_function.py"
  output_path = "./real_time/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_processor" {
  filename      = data.archive_file.seoul-lambda.output_path
  function_name = "day3-real-time-function"
  role          = aws_iam_role.day3-lambda.arn
  timeout = "60"
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.seoul-lambda.output_base64sha256
  runtime       = "python3.12"
}