variable "aws_region" {}

variable "apex_function_dynamic_dynamodb" {}

variable "name" {
  default = "lambda_dynamic_dynamodb"
}

variable "rcu_threshold" {
  default = 80
}

variable "wcu_threshold" {
  default = 80
}

variable "email_address" {
  default = ""
}
