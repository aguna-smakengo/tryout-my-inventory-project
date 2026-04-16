resource "aws_sns_topic" "main" {
  name = "inventory-low-stock-alert"

  tags = {
    Name    = "inventory-low-stock-alert",
    Project = "Smart-Inventory"
  }
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = "feriadiputra05@gmail.com"
}