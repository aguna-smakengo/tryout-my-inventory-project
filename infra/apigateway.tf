resource "aws_api_gateway_rest_api" "main" {
  name = "inventory-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name    = "inventory-api",
    Project = "Smart-Inventory"
  }
}

resource "aws_api_gateway_resource" "barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "barang"
}

resource "aws_api_gateway_resource" "barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.barang.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "history" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.barang_id.id
  path_part   = "history"
}

resource "aws_api_gateway_method" "get_barang" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_barang" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang.id
  http_method             = aws_api_gateway_method.get_barang.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
}

resource "aws_api_gateway_method_response" "get_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.get_barang.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.get_barang.http_method
  status_code = aws_api_gateway_method_response.get_barang.status_code
}

resource "aws_api_gateway_method" "post_barang" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_barang" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang.id
  http_method             = aws_api_gateway_method.post_barang.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
}

resource "aws_api_gateway_method_response" "post_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.post_barang.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "post_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.post_barang.http_method
  status_code = aws_api_gateway_method_response.post_barang.status_code
}

resource "aws_api_gateway_method" "options_barang" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_barang" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang.id
  http_method             = aws_api_gateway_method.options_barang.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.options_barang.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"     = true
  }
}

resource "aws_api_gateway_integration_response" "options_barang" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang.id
  http_method = aws_api_gateway_method.options_barang.http_method
  status_code = aws_api_gateway_method_response.options_barang.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"     = "'*'"
  }
}

resource "aws_api_gateway_method" "put_barang_id" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang_id.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "put_barang_id" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang_id.id
  http_method             = aws_api_gateway_method.put_barang_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

resource "aws_api_gateway_method_response" "put_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.put_barang_id.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "put_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.put_barang_id.http_method
  status_code = aws_api_gateway_method_response.put_barang_id.status_code
}

resource "aws_api_gateway_method" "delete_barang_id" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang_id.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "delete_barang_id" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang_id.id
  http_method             = aws_api_gateway_method.delete_barang_id.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

resource "aws_api_gateway_method_response" "delete_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.delete_barang_id.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "delete_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.delete_barang_id.http_method
  status_code = aws_api_gateway_method_response.delete_barang_id.status_code
}

resource "aws_api_gateway_method" "options_barang_id" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.barang_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "options_barang_id" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.barang_id.id
  http_method             = aws_api_gateway_method.options_barang_id.http_method
  type                    = "MOCK"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.options_barang_id.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"     = true
  }
}

resource "aws_api_gateway_integration_response" "options_barang_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.barang_id.id
  http_method = aws_api_gateway_method.options_barang_id.http_method
  status_code = aws_api_gateway_method_response.options_barang_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"     = "'*'"
  }
}

resource "aws_api_gateway_method" "get_history" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.history.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_integration" "get_history" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.history.id
  http_method             = aws_api_gateway_method.get_history.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}

resource "aws_api_gateway_method_response" "get_history" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.get_history.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_history" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.get_history.http_method
  status_code = aws_api_gateway_method_response.get_history.status_code
}

resource "aws_api_gateway_method" "options_history" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.history.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_history" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.history.id
  http_method             = aws_api_gateway_method.options_history.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_history" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.options_history.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"     = true
  }
}

resource "aws_api_gateway_integration_response" "options_history" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.options_history.http_method
  status_code = aws_api_gateway_method_response.options_history.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"     = "'*'"
  }
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  depends_on = [
    aws_api_gateway_resource.barang,
    aws_api_gateway_method.get_barang,
    aws_api_gateway_integration.get_barang,
    aws_api_gateway_method_response.get_barang,
    aws_api_gateway_integration_response.get_barang,
    aws_api_gateway_method.post_barang,
    aws_api_gateway_integration.post_barang,
    aws_api_gateway_method_response.post_barang,
    aws_api_gateway_integration_response.post_barang,
    aws_api_gateway_method.options_barang,
    aws_api_gateway_integration.options_barang,
    aws_api_gateway_method_response.options_barang,
    aws_api_gateway_integration_response.options_barang,
    aws_api_gateway_method.put_barang_id,
    aws_api_gateway_integration.put_barang_id,
    aws_api_gateway_method_response.put_barang_id,
    aws_api_gateway_integration_response.put_barang_id,
    aws_api_gateway_method.delete_barang_id,
    aws_api_gateway_integration.delete_barang_id,
    aws_api_gateway_method_response.delete_barang_id,
    aws_api_gateway_integration_response.delete_barang_id,
    aws_api_gateway_method.options_barang_id,
    aws_api_gateway_integration.options_barang_id,
    aws_api_gateway_method_response.options_barang_id,
    aws_api_gateway_integration_response.options_barang_id,
    aws_api_gateway_method.get_history,
    aws_api_gateway_integration.get_history,
    aws_api_gateway_method_response.get_history,
    aws_api_gateway_integration_response.get_history,
    aws_api_gateway_method.options_history,
    aws_api_gateway_integration.options_history,
    aws_api_gateway_method_response.options_history,
    aws_api_gateway_integration_response.options_history
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.barang.id,
      aws_api_gateway_method.get_barang.id,
      aws_api_gateway_integration.get_barang.id,
      aws_api_gateway_method_response.get_barang.id,
      aws_api_gateway_integration_response.get_barang.id,
      aws_api_gateway_method.post_barang.id,
      aws_api_gateway_integration.post_barang.id,
      aws_api_gateway_method_response.post_barang.id,
      aws_api_gateway_integration_response.post_barang.id,
      aws_api_gateway_method.options_barang.id,
      aws_api_gateway_integration.options_barang.id,
      aws_api_gateway_method_response.options_barang.id,
      aws_api_gateway_integration_response.options_barang.id,
      aws_api_gateway_method.put_barang_id.id,
      aws_api_gateway_integration.put_barang_id.id,
      aws_api_gateway_method_response.put_barang_id.id,
      aws_api_gateway_integration_response.put_barang_id.id,
      aws_api_gateway_method.delete_barang_id.id,
      aws_api_gateway_integration.delete_barang_id.id,
      aws_api_gateway_method_response.delete_barang_id.id,
      aws_api_gateway_integration_response.delete_barang_id.id,
      aws_api_gateway_method.options_barang_id.id,
      aws_api_gateway_integration.options_barang_id.id,
      aws_api_gateway_method_response.options_barang_id.id,
      aws_api_gateway_integration_response.options_barang_id.id,
      aws_api_gateway_method.get_history.id,
      aws_api_gateway_integration.get_history.id,
      aws_api_gateway_method_response.get_history.id,
      aws_api_gateway_integration_response.get_history.id,
      aws_api_gateway_method.options_history.id,
      aws_api_gateway_integration.options_history.id,
      aws_api_gateway_method_response.options_history.id,
      aws_api_gateway_integration_response.options_history.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "prod"
}
