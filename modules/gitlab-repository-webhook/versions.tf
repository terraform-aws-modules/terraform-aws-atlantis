terraform {
  required_version = ">= 1.1"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 16.0"
    }
  }
}
