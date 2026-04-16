resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "inventory-vpc",
    Project = "Smart-Inventory"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1",
    Project = "Smart-Inventory"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2",
    Project = "Smart-Inventory"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "inventory-rt"
    Project = "Smart-Inventory"
  }
}

resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "inventory-igw",
    Project = "Smart-Inventory"
  }
}

resource "aws_security_group" "sg_lambda" {
  name        = "lambda-sg"
  description = "sg for lambda"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg",
    Project = "Smart-Inventory"
  }
}

resource "aws_security_group" "sg_rds" {
  name        = "rds-sg"
  description = "sg for rds"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups      = [aws_security_group.sg_lambda.id]
  }

  tags = {
    Name = "rds-sg",
    Project = "Smart-Inventory"
  }
}

resource "aws_security_group" "sg_endpoint" {
  name        = "endpoint-sg"
  description = "sg for endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups      = [aws_security_group.sg_lambda.id]
  }

  tags = {
    Name = "endpoint-sg",
    Project = "Smart-Inventory"
  }
}

resource "aws_vpc_endpoint" "sns" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-east-1.sns"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg_endpoint.id,
  ]

  subnet_ids = [
    aws_subnet.subnet_1.id, aws_subnet.subnet_2.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
  route_table_ids = [aws_route_table.main.id]
}