terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }

    bitbucket = {
      source  = "DrFaust92/bitbucket"
      version = ">= 2.17.0"
    }
  }
}
