resource "aws_vpc" "my_vpc" {
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
}

resource "aws_subnet" "my-subnet-2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.1.0.0/16"
  availability_zone = "us-west-1b"
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