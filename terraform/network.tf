resource "aws_vpc" "my_vpc" {
  provider = aws
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "second_cidr_block" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "my-subnet-1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-west-1a"
  depends_on        = [aws_vpc_ipv4_cidr_block_association.second_cidr_block]
}

resource "aws_subnet" "my-subnet-2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.1.0.0/16"
  availability_zone = "us-west-1c"
  depends_on        = [aws_vpc_ipv4_cidr_block_association.second_cidr_block]
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-rt"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.my-subnet-1.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.my-subnet-2.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#aws route53 health check
resource "aws_route53_health_check" "web-server-1" {
  provider = aws
  fqdn = aws_lb.my-lb.dns_name
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  measure_latency = true

  tags = {
    Name = "web-server-1"
  }
}

resource "aws_route53_health_check" "web-server-2" {
  provider = aws.secondary
  fqdn = aws_lb.my-lb_secondary.dns_name
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  measure_latency = true

  tags = {
    Name = "web-server-2"
  }
}

#aws route53 record for failover 2 regions

data "aws_route53_zone" "main" {
  name = "khoah.net"
  private_zone = false
}


resource "aws_route53_record" "web-server-1" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = "web.khoah.net"
  type = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  health_check_id = aws_route53_health_check.web-server-1.id

  alias {
    name = aws_lb.my-lb.dns_name
    zone_id = aws_lb.my-lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "web-server-2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = "web.khoah.net"
  type = "A"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
  health_check_id = aws_route53_health_check.web-server-2.id

  alias {
    name = aws_lb.my-lb_secondary.dns_name
    zone_id = aws_lb.my-lb_secondary.zone_id
    evaluate_target_health = true
  }
}
