#launch template

resource "aws_launch_template" "my_launch_template" {
  name = "my-launch-template"
  image_id = var.primary_ami_id
  key_name = var.primary_kp
  instance_type = "t2.micro"
  security_group_names = [aws_security_group.my_sg.name]
  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              echo "Web Server</h1>" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  
}

#auto scaling group
resource "aws_autoscaling_group" "my_asg" {
  name = "my-asg"
  min_size = 1
  max_size = 2
  health_check_grace_period = 300
  desired_capacity = 1
  vpc_zone_identifier = [aws_subnet.my-subnet-1.id, aws_subnet.my-subnet-2.id]
  launch_template {
    id = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }
  
}