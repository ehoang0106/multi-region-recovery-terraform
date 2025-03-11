# #create sns topic
# resource "aws_sns_topic" "primary-server-unhealthy" {
#   provider = aws.secondary
#   name     = "primary-server-unhealthy"
# }

# resource "aws_sns_topic" "secondary-server-unhealthy" {
#   provider = aws.secondary
#   name     = "secondary-server-unhealthy"
# }


resource "aws_cloudwatch_metric_alarm" "primary-server-unhealthy" {
  provider = aws.secondary
  alarm_name          = "primary-server-unhealthy"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Average"
  
  alarm_actions = [aws_lambda_function.trigger-2nd-server.arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.web-server-1.id
  }
}

resource "aws_cloudwatch_metric_alarm" "primary-server-healthy" {
  provider = aws.secondary
  alarm_name          = "primary-server-healthy"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 1
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Average"
  
  alarm_actions = [aws_lambda_function.trigger-2nd-server-off.arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.web-server-1.id
  }
}