terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 4.8"
    }
  }
}
