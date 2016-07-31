output "lambda_function_role_id" {
  value = "${module.iam.lambda_function_role_id}"
}

output "topic_for_notify_arn" {
  value = "${module.tf_sns_email.arn}"
}

output "topic_for_invoke_arn" {
  value = "${module.sns.arn}"
}

output "dynamodb_arn" {
  value = "${module.dynamodb.arn}"
}

output "dynamodb_table_name" {
  value = "${module.dynamodb.id}"
}
