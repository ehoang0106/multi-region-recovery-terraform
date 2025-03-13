resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my_db_subnet_group"
  subnet_ids = [aws_subnet.my-subnet-1.id, aws_subnet.my-subnet-2.id]

  tags = {
    Name = "my_db_subnet_group"
  }
}

resource "aws_db_instance" "mydb" {
  identifier = "mydb"
  provider = aws
  allocated_storage = 20
  db_name = "mydb"
  engine = "mysql"
  engine_version = "8.0.40"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  publicly_accessible = true
}

