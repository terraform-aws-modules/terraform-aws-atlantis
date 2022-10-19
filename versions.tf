terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.69"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
