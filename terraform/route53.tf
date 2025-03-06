#route53 for checking health of the instances

resource "aws_route53_health_check" "primary_health_check" {
  fqdn = aws_lb.primary_lb.dns_name
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 2
  request_interval = 30
}

resource "aws_route53_health_check" "secondady_health_check" {
  fqdn = aws_lb.secondary_lb.dns_name
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 2
  request_interval = 30
}

resource "aws_route53_record" "primary_record" {
  zone_id = var.zone_id
  name = "khoah.com"
  type = "A"

  set_identifier = "primary-region"
  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name = aws_lb.primary_lb.dns_name
    zone_id = aws_lb.primary_lb.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary_health_check.id

}

resource "aws_route53_record" "secondary_record" {
  zone_id = var.zone_id
  name = "khoah.com"
  type = "A"

  set_identifier = "secondary-region"
  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name = aws_lb.secondary_lb.dns_name
    zone_id = aws_lb.secondary_lb.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.secondady_health_check.id
}