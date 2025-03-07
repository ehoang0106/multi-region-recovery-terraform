#target group

resource "aws_lb_target_group" "my_tg" {
  name = "my-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id
}

#load balancer
resource "aws_lb" "my-lb" {
  name = "my-lg"
  internal = false
  load_balancer_type = "application"
  vpc_id = aws_vpc.my_vpc.id
  security_groups = [aws_security_group.my_sg.id]
  subnets = [for subnet in aws_subnet.public : subnet.id]
}

#listener

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}