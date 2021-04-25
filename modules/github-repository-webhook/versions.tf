terraform {
  required_version = ">= 0.13.1"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.8"
    }
  }
}
