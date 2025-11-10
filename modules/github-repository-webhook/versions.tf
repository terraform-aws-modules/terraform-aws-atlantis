terraform {
  required_version = ">= 1.10"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
  }
}
