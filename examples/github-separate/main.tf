provider "aws" {
  region = local.region
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
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

  # Existing cluster
  create_cluster = false
  cluster_arn    = module.ecs_cluster.arn

  # Existing ALB
  create_alb            = false
  alb_target_group_arn  = module.alb.target_groups["atlantis"].arn
  alb_security_group_id = module.alb.security_group_id

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
    fqdn = module.alb.dns_name
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

  tags = local.tags
}

module "github_repository_webhooks" {
  source = "../../modules/github-repository-webhook"

  repositories = var.repositories

  webhook_url    = "http://${module.alb.dns_name}/events"
  webhook_secret = random_password.webhook_secret.result
}

module "atlantis_disabled" {
  source = "../../"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "6.7.0"

  # Cluster
  name = local.name
  setting = [{
    name  = "containerInsights"
    value = "enabled"
  }]

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.2.0"

  name = local.name

  # Load balancer
  enable_deletion_protection = false # For example only
  subnets                    = module.vpc.public_subnets

  # Listener(s)
  default_port     = 80
  default_protocol = "HTTP"
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "atlantis"
      }
    }
  }

  # Target group(s)
  target_groups = {
    atlantis = {
      backend_protocol                  = "HTTP"
      backend_port                      = 4141
      create_attachment                 = false
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/healthz"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  }

  # Security group
  vpc_id = module.vpc.vpc_id
  security_group_ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = local.tags
}

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
