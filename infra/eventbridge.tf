resource "aws_scheduler_schedule" "main" {
  name       = "inventory-hourly-check"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 * * * ? *)"

  target {
    arn      = aws_lambda_function.low_stock.arn
    role_arn = "arn:aws:iam::${var.account_id}:role/LabRole"
  }
}