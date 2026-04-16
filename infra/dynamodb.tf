resource "aws_dynamodb_table" "main" {
  name           = "inventory-activity-log"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "log_id"

  attribute {
    name = "log_id"
    type = "S"
  }

  attribute {
    name = "barang_id"
    type = "S"
  }

  global_secondary_index {
    name               = "barang_id-index"
    key_schema {
      attribute_name = "barang_id"
      key_type       = "HASH"
    }
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "ALL"
  }

  tags = {
    Name    = "inventory-activity-log",
    Project = "Smart-Inventory"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 100
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.main.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = 100
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.main.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}