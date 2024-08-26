data "aws_region" "cloudwatch" {}

variable "rds_total_memory" {
  default = 1073741824 # 16 GB를 바이트로 변환한 값
}

variable "env" {
  default = "$"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "apdev-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",
              "LoadBalancer",
              "${aws_lb.day3-lb.arn_suffix}",
              {
                "label": "ELB_5XX_Count: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Sum",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "ALB_HTTP_5XX_ERROR"
        }
      },
      {
        type   = "metric",
        x      = 6,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_4XX_Count",
              "LoadBalancer",
              "${aws_lb.day3-lb.arn_suffix}",
              {
                "label": "ELB_4XX_Count: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Sum",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "ALB_HTTP_4XX_ERROR"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              "${aws_lb.day3-lb.arn_suffix}",
              {
                "label": "RequestCount: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Sum",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "ALB_HTTP_COUNT"
        }
      },
      {
        type   = "metric",
        x      = 18,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              "${aws_lb.day3-lb.arn_suffix}",
              {
                "label": "TargetResponseTime: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Maximum",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "ALB_RESPONSE_TIME"
        }
      },
      # {
      #   type   = "metric",
      #   x      = 0,
      #   y      = 7,
      #   width  = 6,
      #   height = 6,
      #   properties = {
      #     metrics = [
      #       [
      #         "AWS/EC2",
      #         "CPUUtilization",
      #         "AutoScalingGroupName",
      #         "${aws_autoscaling_group.day3-token.name}",
      #         {
      #           "label": "TOKEN ASG CPU: ${var.env}{LAST}"
      #         }
      #       ]
      #     ],
      #     view = "timeSeries",
      #     stacked = true,
      #     period = 30,
      #     stat   = "Average",
      #     region = "${data.aws_region.cloudwatch.name}",
      #     title  = "Token_CPU"
      #   }
      # },
      # {
      #   type   = "metric",
      #   x      = 6,
      #   y      = 7,
      #   width  = 6,
      #   height = 6,
      #   properties = {
      #     metrics = [
      #       [
      #         "AWS/EC2",
      #         "CPUUtilization",
      #         "AutoScalingGroupName",
      #         "${aws_autoscaling_group.day3-employee.name}",
      #         {
      #           "label": "EMPLOYEE ASG CPU: ${var.env}{LAST}"
      #         }
      #       ]
      #     ],
      #     view = "timeSeries",
      #     stacked = true,
      #     period = 30,
      #     stat   = "Average",
      #     region = "${data.aws_region.cloudwatch.name}",
      #     title  = "Employee_CPU"
      #   }
      # },
      {
        type   = "metric",
        x      = 12,
        y      = 7,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "EC2 Instance Count",
              "AppInstanceCount",
              {
                "label": "Instance Count: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Minimum",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "EC2_Count"
        }
      },
      # {
      #   type   = "log",
      #   x      = 0,
      #   y      = 14,
      #   width  = 12,
      #   height = 6,
      #   properties = {
      #     title          = "Employee Access Logs",
      #     query          = "SOURCE '/application/employee' | fields @timestamp, @message | filter @message not like \"/healthcheck\" | filter @message not like \"[GIN-debug]\" | filter @message not like \"Please\" | sort @timestamp desc",
      #     region         = "ap-northeast-2",
      #     logGroupNames  = ["/application/employee"],
      #     stacked        = false,
      #     view           = "table"
      #   }
      # },
      # {
      #   type   = "log",
      #   x      = 12,
      #   y      = 14,
      #   width  = 12,
      #   height = 6,
      #   properties = {
      #     title          = "Token Access Logs",
      #     query          = "SOURCE '/application/token' | fields @timestamp, @message | filter @message not like \"/healthcheck\" | filter @message not like \"[GIN-debug]\" | filter @message not like \"Please\" | sort @timestamp desc",
      #     region         = "ap-northeast-2",
      #     logGroupNames  = ["/application/token"],
      #     stacked        = false,
      #     view           = "table"
      #   }
      # },
      {
        type   = "metric",
        x      = 0,
        y      = 21,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "FreeableMemory",
              "DBInstanceIdentifier",
              "${aws_db_instance.db.identifier}",
              { "id": "freeableMemory", "visible": false }
            ],
            [
              {
                "expression": "(((${var.rds_total_memory}-freeableMemory)/1024)/1024)/1024",
                "label": "Memory Utilization: ${var.env}{LAST}",
                "id": "e1"
              }
            ]
          ],
          period = 30,
          stat   = "Average",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "RDS Memory Utilization"
        }
      },
      {
        type   = "metric",
        x      = 6,
        y      = 21,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              "${aws_db_instance.db.identifier}",
              {
                "label": "RDS CPU: ${var.env}{LAST}"
              }
            ]
          ],
          view = "timeSeries",
          stacked = true,
          period = 30,
          stat   = "Average",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "RDS_CPU"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 21,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              {
                "expression": "m1 * 1000",
                "label": "ReadLatency (ms)",
                "id": "e1",
                "label": "ReadLatency : ${var.env}{LAST}"
              }
            ],
            [
              "AWS/RDS",
              "ReadLatency",
              "DBInstanceIdentifier",
              "${aws_db_instance.db.identifier}",
              { "id": "m1", "visible": false }
            ]
          ],
          period = 30,
          stat   = "Average",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "ReadLatency"
        }
      },
      {
        type   = "metric",
        x      = 18,
        y      = 21,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            [
              {
                "expression": "m1 * 1000",
                "label": "WriteLatency (ms)",
                "id": "e1",
                "label": "WriteLatency : ${var.env}{LAST}"
              }
            ],
            [
              "AWS/RDS",
              "WriteLatency",
              "DBInstanceIdentifier",
              "${aws_db_instance.db.identifier}",
              { "id": "m1", "visible": false }
            ]
          ],
          period = 30,
          stat   = "Average",
          region = "${data.aws_region.cloudwatch.name}",
          title  = "WriteLatency"
        }
      }
    ]
  })
  # depends_on = [ aws_autoscaling_group.day3-token,aws_autoscaling_group.day3-employee,aws_lambda_function.day3-lambda ]
}

resource "aws_cloudwatch_log_group" "day3" {
  provider = aws.us-east-1
  name = "aws-waf-logs-day3"
  tags = {
    Name = "aws-waf-logs-day3"
  }
}

resource "aws_cloudwatch_log_group" "cf" {
  name = "cloudfront_log"
  tags = {
    Name = "cloudfront_log"
  }
}

resource "aws_cloudwatch_log_metric_filter" "emp_all" {
  name           = "employee_all_count"
  pattern        = "{$.url=%/v1/employee%}"
  log_group_name = aws_cloudwatch_log_group.cf.name

  metric_transformation {
    namespace = "cf"
    name      = "employee_all_count"
    value     = "1"
    default_value = "0"
    unit      = "Count"
  }
}

# resource "aws_cloudwatch_log_metric_filter" "emp_GET" {
#   name           = "employee-GET"
#   pattern        = "{($.status_code="200") && ($.url=%/v1/employee?%)}"
#   log_group_name = aws_cloudwatch_log_group.cf.name

#   metric_transformation {
#     namespace = "cf"
#     name      = "employee_get"
#     value     = "1"
#     default_value = "0"
#     unit      = "Count"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "emp_POST" {
#   name           = "employee-GET"
#   pattern        = "{($.status_code="201") && ($.url=%/v1/employee%)}"
#   log_group_name = aws_cloudwatch_log_group.cf.name

#   metric_transformation {
#     namespace = "cf"
#     name      = "employee_POST"
#     value     = "1"
#     default_value = "0"
#     unit      = "Count"
#   }
# }
resource "aws_cloudwatch_log_metric_filter" "token_all" {
  name           = "token-all"
  pattern        = "{$.url=%/v1/token%}"
  log_group_name = aws_cloudwatch_log_group.cf.name

  metric_transformation {
    namespace = "cf"
    name      = "token_all_count"
    value     = "1"
    default_value = "0"
    unit      = "Count"
  }
}

# resource "aws_cloudwatch_log_metric_filter" "token_201" {
#   name           = "token-all"
#   pattern        = "{($.status_code="201") && ($.url=%/v1/token%)}"
#   log_group_name = aws_cloudwatch_log_group.cf.name

#   metric_transformation {
#     namespace = "cf"
#     name      = "token_201"
#     value     = "1"
#     default_value = "0"
#     unit      = "Count"
#   }
# }
