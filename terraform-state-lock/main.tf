resource "aws_dynamodb_table" "terraform-codeserver-state-lock" {
  name         = "terraform-codeserver-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}