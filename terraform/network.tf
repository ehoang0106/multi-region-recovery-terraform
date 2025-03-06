#vpc

resource "aws_vpc" "primary" {
  provider = aws
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "primary-vpc"
  }
}

resource "aws_vpc" "secondary" {
  provider = aws.secondary
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "secondary-vpc"
  }
}

#subnet

resource "aws_subnet" "primary_subnet" {
  provider = aws
  vpc_id = aws_vpc.primary.id
  cidr_block = "10.0.0.0/24" 

  tags = {
    Name = "primary-subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary.id
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "secondary-subnet"
  }
}

#security group

resource "aws_security_group" "web_primary_sg" {
  provider = aws
  vpc_id = aws_vpc.primary.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_secondary_sg" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}