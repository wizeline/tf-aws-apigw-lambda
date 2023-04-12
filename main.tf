#-----------------------------------------------------------
# IAM
#-----------------------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "logs" {
  name        = "${var.name}-logs"
  description = "Write logs from Lambda"
  policy      = data.aws_iam_policy_document.logs.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logs.arn
}

#-----------------------------------------------------------
# Lambda
#-----------------------------------------------------------
resource "aws_lambda_function" "this" {
  function_name = var.name
  runtime       = var.runtime
  role          = aws_iam_role.this.arn
  handler       = var.handler
  filename      = var.filename

  tags = var.tags
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.apigateway_execution_arn}/*/*"
}

############# CloudWatch #############
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.name}"
  retention_in_days = var.cloudwatch_log_group_retention

  tags = var.tags
}

#-----------------------------------------------------------
# API Gateway
#-----------------------------------------------------------
resource "aws_apigatewayv2_stage" "this" {
  name        = var.name
  api_id      = var.apigateway_api_id
  auto_deploy = true

  tags = var.tags
}

resource "aws_apigatewayv2_integration" "this" {
  api_id = var.apigateway_api_id

  integration_uri    = aws_lambda_function.this.invoke_arn
  integration_type   = var.apigateway_integration_type
  integration_method = var.apigateway_integration_method
}

resource "aws_apigatewayv2_route" "this" {
  api_id = var.apigateway_api_id

  route_key = "${var.apigateway_route_key_method} ${var.apigateway_route_key_path}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}
