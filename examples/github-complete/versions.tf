terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.68"
    }

    github = {
      source  = "integrations/github"
      version = ">= 2.4.1"
    }
  }
}
