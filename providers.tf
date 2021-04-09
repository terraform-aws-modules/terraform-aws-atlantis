provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket               = "tophat-terraform-state"
    key                  = "state.tfstate"
    workspace_key_prefix = "atlantis-service"
    region               = "us-east-1"
    dynamodb_table       = "tophat-terraform-state-locks"
    acl                  = "bucket-owner-full-control"
  }
}
