resource "aws_vpc" "my_vpc_secondary" {
  provider = aws.secondary
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc_secondary"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "second_cidr_block_secondary" {
  provider = aws.secondary
  vpc_id     = aws_vpc.my_vpc_secondary.id
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "my-subnet-1_secondary" {
  provider = aws.secondary
  vpc_id            = aws_vpc.my_vpc_secondary.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-east-1a"
  depends_on        = [aws_vpc_ipv4_cidr_block_association.second_cidr_block_secondary]

  tags = {
    Name = "my-subnet-1_secondary"
  }
}

resource "aws_subnet" "my-subnet-2_secondary" {
  provider = aws.secondary
  vpc_id            = aws_vpc.my_vpc_secondary.id
  cidr_block        = "10.1.0.0/16"
  availability_zone = "us-east-1c"
  depends_on        = [aws_vpc_ipv4_cidr_block_association.second_cidr_block_secondary]

  tags = {
    Name = "my-subnet-2_secondary"
  }
}

resource "aws_internet_gateway" "my_igw_secondary" {
  provider = aws.secondary
  vpc_id = aws_vpc.my_vpc_secondary.id

  tags = {
    Name = "my-igw_secondary"
  }
}

resource "aws_route_table" "my_rt_secondary" {
  provider = aws.secondary
  vpc_id = aws_vpc.my_vpc_secondary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw_secondary.id
  }

  tags = {
    Name = "my-rt_secondary"
  }
}

resource "aws_route_table_association" "route_table_association_1_secondary" {
  provider = aws.secondary
  subnet_id      = aws_subnet.my-subnet-1_secondary.id
  route_table_id = aws_route_table.my_rt_secondary.id
}

resource "aws_route_table_association" "route_table_association_2_secondary" {
  provider = aws.secondary
  subnet_id      = aws_subnet.my-subnet-2_secondary.id
  route_table_id = aws_route_table.my_rt_secondary.id
}

resource "aws_security_group" "my_sg_secondary" {
  provider = aws.secondary
  vpc_id = aws_vpc.my_vpc_secondary.id

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
    Name = "my_sg_secondary"
  }
}