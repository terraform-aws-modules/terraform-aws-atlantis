terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.68"
    }

    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.0"
    }
  }
}
