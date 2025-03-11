resource "aws_cloudwatch_metric_alarm" "primary_lb_unhealthy" {
  provider = aws
  alarm_name          = "PrimaryLBUnhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  dimensions = {
    LoadBalancerName = aws_lb.my-lb.id
  }

}

