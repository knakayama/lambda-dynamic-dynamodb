resource "aws_dynamodb_table" "dynamodb" {
  name           = "${var.name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "N"
  }
}
