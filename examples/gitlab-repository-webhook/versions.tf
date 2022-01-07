terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }

    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.0"
    }
  }
}
