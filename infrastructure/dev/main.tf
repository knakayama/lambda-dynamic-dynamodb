module "iam" {
  source = "../modules/iam"

  name = "${var.name}"
}

module "tf_sns_email" {
  source = "github.com/deanwilson/tf_sns_email"

  display_name  = "${var.name}"
  email_address = "${var.email_address}"
  owner         = "me"
  stack_name    = "${replace(var.name, "_", "-")}"
}

module "sns" {
  source = "../modules/sns"

  name       = "${var.name}"
  lambda_arn = "${var.apex_function_dynamic_dynamodb}"
}

module "dynamodb" {
  source = "../modules/dynamodb"

  name = "${var.name}"
}

module "cloudwatch" {
  source = "../modules/cloudwatch"

  name          = "${var.name}"
  topic_arn     = "${module.sns.arn}"
  rcu_threshold = "${var.rcu_threshold}"
  wcu_threshold = "${var.wcu_threshold}"
}
