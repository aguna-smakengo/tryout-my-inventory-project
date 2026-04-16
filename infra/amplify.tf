resource "aws_amplify_app" "main" {
  name       = "inventory-app"
  repository = "https://github.com/aguna-smakengo/tryout-my-inventory-project.git"
  access_token = var.token

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
version: 1
applications:
  - frontend:
      phases:
        preBuild:
          commands:
            - npm ci --cache .npm --prefer-offline
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - .npm/**/*
    appRoot: frontend
  EOT

  environment_variables = {
    REACT_APP_API_URL = "${aws_api_gateway_stage.main.invoke_url}/barang"
  }

  tags = {
    Name    = "inventory-app",
    Project = "Smart-Inventory"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = "main"

  stage     = "PRODUCTION"
}