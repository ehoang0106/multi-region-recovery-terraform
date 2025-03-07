#target group

resource "aws_lb_target_group" "my_tg" {
  name = "my-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id
}

#load balancer
