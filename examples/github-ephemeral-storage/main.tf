provider "aws" {
  region = local.region
}

locals {
  name   = "github-ephemeral-storage"
  region = "eu-west-1"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}


################################################################################
# Supporting Resources
################################################################################

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "current" {}

##############################################################
# Atlantis Service
##############################################################

module "atlantis" {
  source = "../github-complete"

  domain                   = var.domain
  alb_ingress_cidr_blocks  = var.alb_ingress_cidr_blocks
  github_token             = var.github_token
  github_owner             = var.github_owner
  github_user              = var.github_user
  enable_ephemeral_storage = var.enable_ephemeral_storage
}