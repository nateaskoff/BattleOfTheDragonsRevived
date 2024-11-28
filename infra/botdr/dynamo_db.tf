resource "aws_dynamodb_table" "release_table" {
  name           = "${var.env}-botdr-release-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "version"
  attribute {
    name = "version"
    type = "S"
  }
  tags = {
    Name = "${var.env}-botdr-release-table"
  }
}
