resource "aws_dynamodb_table" "main" {
  name           = "inventory-activity-log"
  billing_mode   = "PAY_PER_REQUEST"
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
    projection_type    = "ALL"
  }

  tags = {
    Name    = "inventory-activity-log",
    Project = "Smart-Inventory"
  }
}