# resource "aws_autoscaling_policy" "scale_up" {
#   name                   = "token_policy_up"
#   autoscaling_group_name = aws_autoscaling_group.day3-employee.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 0
#   depends_on = [ aws_autoscaling_group.day3-token ]
# }

# resource "aws_cloudwatch_metric_alarm" "token_cpu_alarm_up" {
#   alarm_name = "token_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "mem_used_percent"
#   namespace = "CWAgent"
#   period = "60"
#   statistic = "Average"
#   threshold = "70"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.day3-token.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.scale_up.arn ]
# }

# resource "aws_autoscaling_policy" "token_policy_down" {
#   name = "token_policy_down"
#   scaling_adjustment = -1
#   adjustment_type = "ChangeInCapacity"
#   cooldown = 0
#   autoscaling_group_name = aws_autoscaling_group.day3-token.name
# }


# resource "aws_cloudwatch_metric_alarm" "token_cpu_alarm_down" {
#   alarm_name = "token_cpu_alarm_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "mem_used_percent"
#   namespace = "CWAgent"
#   period = "60"
#   statistic = "Average"
#   threshold = "10"
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.day3-token.name
#   }
#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.token_policy_down.arn ]
# }

# resource "aws_autoscaling_policy" "employee_scale_up" {
#   name                   = "employee_policy_up"
#   autoscaling_group_name = aws_autoscaling_group.day3-employee.name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 0
#   depends_on = [ aws_autoscaling_group.day3-employee ]
# }

# resource "aws_cloudwatch_metric_alarm" "employee_cpu_alarm_up" {
#   alarm_name = "employee_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "mem_used_percent"
#   namespace = "CWAgent"
#   period = "60"
#   statistic = "Average"
#   threshold = "70"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.day3-employee.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.employee_scale_up.arn ]
# }

# resource "aws_autoscaling_policy" "employee_policy_down" {
#   name = "employee_policy_down"
#   scaling_adjustment = -1
#   adjustment_type = "ChangeInCapacity"
#   cooldown = 0
#   autoscaling_group_name = aws_autoscaling_group.day3-employee.name
# }


# resource "aws_cloudwatch_metric_alarm" "employee_cpu_alarm_down" {
#   alarm_name = "employee_cpu_alarm_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "mem_used_percent"
#   namespace = "CWAgent"
#   period = "60"
#   statistic = "Average"
#   threshold = "10"
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.day3-employee.name
#   }
#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions = [ aws_autoscaling_policy.employee_policy_down.arn ]
# }

# # resource "aws_appautoscaling_policy" "gyeongbuk-memory" {
# #   name               = "memory"
# #   policy_type        = "TargetTrackingScaling"
# #   resource_id        = aws_appautoscaling_target.gyeongbuk-tg.resource_id
# #   scalable_dimension = aws_appautoscaling_target.gyeongbuk-tg.scalable_dimension
# #   service_namespace  = aws_appautoscaling_target.gyeongbuk-tg.service_namespace

# #   target_tracking_scaling_policy_configuration {
# #     predefined_metric_specification {
# #       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
# #     }

# #     target_value       = 70
# #   }
# # }

# # resource "aws_appautoscaling_policy" "gyeongbuk-cpu" {
# #   name = "cpu"
# #   policy_type = "TargetTrackingScaling"
# #   resource_id = aws_appautoscaling_target.gyeongbuk-tg.resource_id
# #   scalable_dimension = aws_appautoscaling_target.gyeongbuk-tg.scalable_dimension
# #   service_namespace = aws_appautoscaling_target.gyeongbuk-tg.service_namespace

# #   target_tracking_scaling_policy_configuration {
# #     predefined_metric_specification {
# #       predefined_metric_type = "ECSServiceAverageCPUUtilization"
# #     }

# #     target_value = 70
# #   }
# # }