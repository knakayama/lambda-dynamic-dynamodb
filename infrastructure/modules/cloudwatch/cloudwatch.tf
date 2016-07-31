resource "aws_cloudwatch_metric_alarm" "rcu_scale_out" {
  alarm_name          = "rcu_scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedReadCapacityUnits"
  period              = 60
  namespace           = "AWS/DynamoDB"
  statistic           = "Average"
  threshold           = "0.5"
  alarm_actions       = ["${var.topic_arn}"]

  dimensions {
    TableName = "${var.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "wcu_scale_out" {
  alarm_name          = "wcu_scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedWriteCapacityUnits"
  period              = 60
  namespace           = "AWS/DynamoDB"
  statistic           = "Average"
  threshold           = "0.5"
  alarm_actions       = ["${var.topic_arn}"]

  dimensions {
    TableName = "${var.name}"
  }
}
