provider "aws" {
  region = local.region
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

data "aws_route53_zone" "this" {
  name = var.domain
}

data "aws_availability_zones" "available" {}

locals {
  region = "eu-west-1"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-atlantis"
  }
}

##############################################################
# Atlantis
##############################################################

module "atlantis" {
  source = "../../"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  # ECS Container Definition
  atlantis = {
    environment = [
      {
        name  = "ATLANTIS_GH_USER"
        value = var.atlantis_github_user
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = join(",", var.atlantis_repo_allowlist)
      },
      {
        name  = "ATLANTIS_ENABLE_DIFF_MARKDOWN_FORMAT"
        value = "true"
      },
    ]
    secrets = [
      {
        name      = "ATLANTIS_GH_TOKEN"
        valueFrom = try(module.secrets_manager["github-token"].secret_arn, "")
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom = try(module.secrets_manager["github-webhook-secret"].secret_arn, "")
      },
    ]
  }

  # ECS Service
  service = {
    subnet_ids = module.vpc.private_subnets

    task_exec_secret_arns = [for sec in module.secrets_manager : sec.secret_arn]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }

  # ALB
  alb = {
    subnet_ids = module.vpc.public_subnets

    # For example only
    enable_deletion_protection = false
  }

  # ACM
  certificate_domain_name = "${local.name}.${var.domain}"
  route53_zone_id         = data.aws_route53_zone.this.id

  # EFS
  enable_efs = true
  efs = {
    mount_targets = {
      "eu-west-1a" = {
        subnet_id = module.vpc.private_subnets[0]
      }
      "eu-west-1b" = {
        subnet_id = module.vpc.private_subnets[1]
      }
      "eu-west-1c" = {
        subnet_id = module.vpc.private_subnets[2]
      }
    }
  }

  tags = local.tags
}

module "github_repository_webhooks" {
  source = "../../modules/github-repository-webhook"

  repositories = var.repositories

  webhook_url    = "${module.atlantis.url}/events"
  webhook_secret = random_password.webhook_secret.result
}

################################################################################
# Supporting Resources
################################################################################

resource "random_password" "webhook_secret" {
  length  = 32
  special = false
}

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 2.0"

  for_each = {
    github-token = {
      secret_string = var.github_token
    }
    github-webhook-secret = {
      secret_string = random_password.webhook_secret.result
    }
  }

  # Secret
  name_prefix              = each.key
  recovery_window_in_days  = 0 # For example only
  secret_string_wo         = each.value.secret_string
  secret_string_wo_version = 2

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
