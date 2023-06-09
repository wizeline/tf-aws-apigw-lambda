#-----------------------------------------------------------
# Common
#-----------------------------------------------------------
variable "name" {
  type        = string
  description = "(Required) Name of the API. This name will be used in all resources"
}

variable "tags" {
  type        = map(string)
  description = " (Optional) Tags applied to all resources."
  default     = {}
}

#-----------------------------------------------------------
# Lambda
#-----------------------------------------------------------
variable "runtime" {
  type        = string
  description = "(Optional) Identifier of the function's runtime. See [Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime) for valid values."
  default     = "nodejs14.x"
}

variable "handler" {
  type        = string
  description = "(Required) Function entrypoint in your code"
}

variable "filename" {
  type        = string
  description = "(Required) Path to the function's deployment package within the local filesystem. Exactly one of filename, image_uri, or s3_bucket must be specified"
}

variable "environment_variables" {
  type        = map(string)
  description = "(Optional) Map of environment variables that are accessible from the function code during execution. If provided at least one key must be present."
  default     = {}
}

#-----------------------------------------------------------
# CloudWatch Logs
#-----------------------------------------------------------
variable "cloudwatch_log_group_retention" {
  type        = number
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 14
}

#-----------------------------------------------------------
# API Gateway
#-----------------------------------------------------------
variable "apigateway_version" {
  type        = string
  description = "(Optional) Type of the API Gateway. Use v1 for REST APIs and v2 for HTTP/WEBSOCKET APIs."
  default     = "v2"
}

variable "apigateway_api_id" {
  type        = string
  description = "(Required) API identifier."
}

variable "apigateway_execution_arn" {
  type        = string
  description = "(Required) ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API. See the Amazon [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-control-access-iam.html) for details."
}

variable "apigateway_root_resource_id" {
  type        = string
  description = "(Optional) Only for API Gateway v1. Set to the ID of the API Gateway Resource on the found REST API where the route matches '/'."
  default     = null
}

variable "apigateway_integration_type" {
  type        = string
  description = "(Optional) Integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP_PROXY."
  default     = "AWS_PROXY"
}

variable "apigateway_integration_method" {
  type        = string
  description = "(Optional) Integration's HTTP method. Must be specified if integration_type is not MOCK."
  default     = "POST"
}

variable "apigateway_route_key_method" {
  type        = string
  description = "(Required) Method for the route. This method is the one that your code is expecting."
}

variable "apigateway_route_key_path" {
  type        = string
  description = "(Optional) Path for the route. This route will be attached to end API Gateway or custom DNS endpoint."
  default     = ""
}

variable "custom_domain_enabled" {
  type        = bool
  description = "(Optional) If you want a custom domain name for your resource. You must have a Custom Domain in your API."
  default     = false
}

variable "custom_domain_name" {
  type        = string
  description = "(Optional) Domain name. Must be between 1 and 512 characters in length."
  default     = ""
}

variable "allowed_ips" {
  type        = list(string)
  description = "(Optional) Only for v1 APIs. List of IP addresses in CIDR notation that are allowed to call your API. Default allows the traffic from any IP."
  default     = null
}

#-----------------------------------------------------------
# VPC
#-----------------------------------------------------------
variable "custom_vpc_enabled" {
  type        = bool
  description = "(Optional) Enable deployment of the Lambda function to a custom VPC."
  default     = false
}

variable "security_groups_ids" {
  type        = list(string)
  description = "(Optional) List of security group IDs associated with the Lambda function."
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Optional) List of subnet IDs associated with the Lambda function."
  default     = []
}
