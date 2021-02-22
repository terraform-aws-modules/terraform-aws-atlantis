terraform {
  required_version = ">= 0.13"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.0"
    }
  }
}
