terraform {
  required_version = ">= 0.13.1"

  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      # gitlab provider requires terraform 1.0 or later starting in 15.x.x
      version = "3.20.0"
    }
  }
}
