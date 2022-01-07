terraform {
  required_version = ">= 0.13.1"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.0"
    }
  }
}
