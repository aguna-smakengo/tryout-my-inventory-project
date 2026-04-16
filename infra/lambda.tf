resource "aws_lambda_layer_version" "main" {
  filename   = "../backend/layer.zip"
  layer_name = "psycopg2-layer"

  compatible_runtimes = ["python3.12"]
}

data "archive_file" "api" {
  type        = "zip"
  source_file = "../backend/lambda_inventory_management.py"
  output_path = "../backend/lambda_inventory_management.zip"
}

resource "aws_lambda_function" "api" {
  filename      = data.archive_file.api.output_path
  function_name = "inventory-api"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "lambda_inventory_management.handler"

  layers = [aws_lambda_layer_version.main.arn]

  runtime = "python3.12"
  timeout = 30

  environment {
    variables = {
      DATABASE_HOST = aws_db_instance.main.address
      DATABASE_NAME   = "inventory_db"
      DATABASE_USER   = aws_db_instance.main.username
      DATABASE_PASS   = var.db_password
      DYNAMODB_TABLE   = aws_dynamodb_table.main.name
    }
  }

  vpc_config {
    subnet_ids                  = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids          = [aws_security_group.sg_lambda.id]
  }

  tags = {
    Name = "inventory-api",
    Project = "Smart-Inventory"
  }
}

resource "aws_lambda_permission" "allow_api" {
  statement_id  = "allowfromapi"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "low_stock" {
  type        = "zip"
  source_file = "../backend/lambda_low_stock_checker.py"
  output_path = "../backend/lambda_low_stock_checker.zip"
}

resource "aws_lambda_function" "low_stock" {
  filename      = data.archive_file.low_stock.output_path
  function_name = "inventory-low-stock-checker"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "lambda_low_stock_checker.handler"

  layers = [aws_lambda_layer_version.main.arn]

  runtime = "python3.12"
  timeout = 30

  environment {
    variables = {
      DATABASE_HOST = aws_db_instance.main.address
      DATABASE_NAME   = "inventory_db"
      DATABASE_USER   = aws_db_instance.main.username
      DATABASE_PASS   = var.db_password
      SNS_TOPIC_ARN   = aws_sns_topic.main.arn
    }
  }

  vpc_config {
    subnet_ids                  = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids          = [aws_security_group.sg_lambda.id]
  }

  tags = {
    Name = "inventory-low-stock-checker",
    Project = "Smart-Inventory"
  }
}

resource "aws_lambda_permission" "allow_low_stock" {
  statement_id  = "allowlowstockinvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.low_stock.function_name
  principal     = "events.amazonaws.com"
}