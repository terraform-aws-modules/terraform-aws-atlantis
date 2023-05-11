terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }

    gitlab = {
      # gitlab provider requires terraform 1.0 or later starting in 15.x.x
      source  = "gitlabhq/gitlab"
      version = "3.20.0"
    }
  }
}
