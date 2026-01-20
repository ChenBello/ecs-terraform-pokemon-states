# MONITORING AND ALERTS

#################################################################################################
# CloudWatch Log Group
#################################################################################################

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.app_name}-ecs-logs"
    Environment = var.environment
  }
}

#################################################################################################
# Log Metric Filters
#################################################################################################

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "${var.app_name}-error-filter"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
  pattern        = "[ERROR]"

  metric_transformation {
    name      = "${var.app_name}-error-count"
    namespace = "CustomApp/Metrics"
    value     = "1"
    default_value = 0
  }
}

resource "aws_cloudwatch_log_metric_filter" "exception_filter" {
  name           = "${var.app_name}-exception-filter"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
  pattern        = "?Exception ?exception"

  metric_transformation {
    name      = "${var.app_name}-exception-count"
    namespace = "CustomApp/Metrics"
    value     = "1"
    default_value = 0
  }
}

#################################################################################################
# SNS Topic
#################################################################################################

resource "aws_sns_topic" "alerts" {
  name         = "${var.app_name}-alerts"
  display_name = "${var.app_name} Alerts"

  tags = {
    Name        = "${var.app_name}-alerts"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

#################################################################################################
# CloudWatch Alarms
#################################################################################################

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "${var.app_name}-high-error-rate"
  alarm_description   = "Triggers when ERROR log entries exceed threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.app_name}-error-count"
  namespace           = "CustomApp/Metrics"
  period              = 300
  statistic           = "Sum"
  threshold           = var.error_threshold
  treat_missing_data  = "notBreaching"
  
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.app_name}-error-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "exception_alarm" {
  alarm_name          = "${var.app_name}-high-exception-rate"
  alarm_description   = "Triggers when Exception log entries exceed threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.app_name}-exception-count"
  namespace           = "CustomApp/Metrics"
  period              = 300
  statistic           = "Sum"
  threshold           = var.exception_threshold
  treat_missing_data  = "notBreaching"
  
  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.app_name}-exception-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_utilization" {
  alarm_name          = "${var.app_name}-high-cpu-utilization"
  alarm_description   = "Triggers when ECS service CPU utilization exceeds threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.app_name}-cpu-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_utilization" {
  alarm_name          = "${var.app_name}-high-memory-utilization"
  alarm_description   = "Triggers when ECS service memory utilization exceeds threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.memory_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "${var.app_name}-memory-alarm"
  }
}

