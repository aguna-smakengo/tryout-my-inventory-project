resource "aws_db_subnet_group" "subnet_rds" {
  name       = "subnet-rds"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "subnet-rds",
    Project = "Smart-Inventory"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = 200
  identifier           = "inventory-db"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.subnet_rds.id
  vpc_security_group_ids = [aws_security_group.sg_rds.id]
  skip_final_snapshot  = true

  tags = {
    Name = "inventory-db",
    Project = "Smart-Inventory"
  }
}