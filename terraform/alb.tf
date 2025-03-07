#target group

resource "aws_lb_target_group" "my_tg" {
  name        = "my-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
}

#load balancer
resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.my_sg.id]
  #subnet
  subnets = [aws_subnet.my-subnet-1.id, aws_subnet.my-subnet-2.id]
}

#listener

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_lb_listener" "my_listener_https" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.cert_arn
}
