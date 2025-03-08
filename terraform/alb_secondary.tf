#target group

resource "aws_lb_target_group" "my_tg_secondary" {
  provider = aws.secondary
  name        = "my-tg-secondary"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc_secondary.id
}

#load balancer

resource "aws_lb" "my-lb_secondary" {
  provider = aws.secondary
  name               = "my-lb-secondary"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.my_sg_secondary.id]
  #subnet
  subnets = [aws_subnet.my-subnet-1_secondary.id, aws_subnet.my-subnet-2_secondary.id]
}

#listener

resource "aws_lb_listener" "my_listener_secondary" {
  provider = aws.secondary
  load_balancer_arn = aws_lb.my-lb_secondary.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg_secondary.arn
  }
}

resource "aws_lb_listener" "my_listener_https_secondary" {
  provider = aws.secondary
  load_balancer_arn = aws_lb.my-lb_secondary.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg_secondary.arn
  }
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.cert_arn_secondary
}