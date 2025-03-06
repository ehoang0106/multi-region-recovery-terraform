#ec2

resource "aws_instance" "primary_server" {
  provider = aws
  ami             = var.primary_ami_id
  instance_type   = "t2.micro"
  key_name        = var.primary_kp
  subnet_id       = aws_subnet.primary_subnet_1.id
  security_groups = [aws_security_group.web_primary_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Primary Server - us-west-1</h1>" > /var/www/html/index.html
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "primary-server"
  }
}

resource "aws_instance" "secondary_server" {
  provider = aws.secondary
  ami             = var.secondary_ami_id
  instance_type   = "t2.micro"
  key_name        = var.secondary_kp
  subnet_id       = aws_subnet.secondary_subnet_1.id
  security_groups = [aws_security_group.web_secondary_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "<h1>Secondary Server - us-east-1</h1>" > /var/www/html/index.html
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "secondary-server"
  }
}