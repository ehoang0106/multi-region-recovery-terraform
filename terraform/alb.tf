# #application load balancer listener

# resource "aws_lb" "primary_lb" {
#   provider           = aws
#   name               = "primary-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.web_primary_sg.id]
# 
#   subnets            = [aws_subnet.primary_subnet_1.id, aws_subnet.primary_subnet_2.id]
# }

# resource "aws_lb" "secondary_lb" {
#   provider           = aws.secondary
#   name               = "secondary-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.web_secondary_sg.id]
#   subnets            = [aws_subnet.secondary_subnet_1.id, aws_subnet.secondary_subnet_2.id]
# }