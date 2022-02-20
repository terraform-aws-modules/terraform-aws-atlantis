provider "aws" {
  region = var.region
}

##############################################################
# Atlantis Service
##############################################################

module "atlantis" {
  source = "../github-complete"

  name                     = var.name
  domain                   = var.domain
  alb_ingress_cidr_blocks  = var.alb_ingress_cidr_blocks
  github_token             = var.github_token
  github_owner             = var.github_owner
  github_user              = var.github_user
  enable_ephemeral_storage = var.enable_ephemeral_storage
  tags                     = var.tags
}