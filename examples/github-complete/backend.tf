terraform {
  backend "s3" {
    bucket = "terraform-state-rentcars"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}