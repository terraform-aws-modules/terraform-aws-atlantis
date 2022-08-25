terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "kzk-maeda"
    workspaces {
      name = "atlantis-infra"
    }
  }
}

provider "aws" {
  region                   = "ap-northeast-1"
  version                  = "~>3.69"
}

data "aws_caller_identity" "current" {}

