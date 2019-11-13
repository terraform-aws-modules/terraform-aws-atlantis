locals {
  # VPC - existing or new?
  vpc_id             = var.vpc_id == "" ? module.vpc.vpc_id : var.vpc_id
  private_subnet_ids = coalescelist(module.vpc.private_subnets, var.private_subnet_ids, [""])
  public_subnet_ids  = coalescelist(module.vpc.public_subnets, var.public_subnet_ids, [""])

  # Atlantis
  atlantis_image = var.atlantis_image == "" ? "runatlantis/atlantis:${var.atlantis_version}" : var.atlantis_image
  atlantis_url = "https://${coalesce(
    element(concat(aws_route53_record.atlantis.*.fqdn, [""]), 0),
    module.alb.dns_name,
    "_"
  )}"
  atlantis_url_events = "${local.atlantis_url}/events"

  # Include only one group of secrets - for github, gitlab or bitbucket
  has_secrets = var.atlantis_gitlab_user_token != "" || var.atlantis_github_user_token != "" || var.atlantis_bitbucket_user_token != ""

  secret_name_key = local.has_secrets ? var.atlantis_gitlab_user_token != "" ? "ATLANTIS_GITLAB_TOKEN" : var.atlantis_github_user_token != "" ? "ATLANTIS_GH_TOKEN" : "ATLANTIS_BITBUCKET_TOKEN" : "unknown_secret_name_key"

  secret_name_value_from = local.has_secrets ? var.atlantis_gitlab_user_token != "" ? var.atlantis_gitlab_user_token_ssm_parameter_name : var.atlantis_github_user_token != "" ? var.atlantis_github_user_token_ssm_parameter_name : var.atlantis_bitbucket_user_token_ssm_parameter_name : "unknown_secret_name_value"

  secret_webhook_key = local.has_secrets ? var.atlantis_gitlab_user_token != "" ? "ATLANTIS_GITLAB_WEBHOOK_SECRET" : var.atlantis_github_user_token != "" ? "ATLANTIS_GH_WEBHOOK_SECRET" : "ATLANTIS_BITBUCKET_WEBHOOK_SECRET" : "unknown_secret_webhook_key"

  # Container definitions
  container_definitions = var.custom_container_definitions == "" ? var.atlantis_bitbucket_user_token != "" ? module.container_definition_bitbucket.json : module.container_definition_github_gitlab.json : var.custom_container_definitions

  container_definition_environment = [
    {
      name  = "ATLANTIS_ALLOW_REPO_CONFIG"
      value = var.allow_repo_config
    },
    {
      name  = "ATLANTIS_GITLAB_HOSTNAME"
      value = var.atlantis_gitlab_hostname
    },
    {
      name  = "ATLANTIS_LOG_LEVEL"
      value = "debug"
    },
    {
      name  = "ATLANTIS_PORT"
      value = var.atlantis_port
    },
    {
      name  = "ATLANTIS_ATLANTIS_URL"
      value = local.atlantis_url
    },
    {
      name  = "ATLANTIS_GH_USER"
      value = var.atlantis_github_user
    },
    {
      name  = "ATLANTIS_GITLAB_USER"
      value = var.atlantis_gitlab_user
    },
    {
      name  = "ATLANTIS_BITBUCKET_USER"
      value = var.atlantis_bitbucket_user
    },
    {
      name  = "ATLANTIS_REPO_WHITELIST"
      value = join(",", var.atlantis_repo_whitelist)
    },
  ]

  # Secret access tokens
  container_definition_secrets_1 = [
    {
      name      = local.secret_name_key
      valueFrom = local.secret_name_value_from
    },
  ]

  # Webhook secrets are not supported by BitBucket
  container_definition_secrets_2 = [
    {
      name      = local.secret_webhook_key
      valueFrom = var.webhook_ssm_parameter_name
    },
  ]

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  count = var.create_route53_record ? 1 : 0

  name         = var.route53_zone_name
  private_zone = false
}

###################
# Secret for webhook
###################
resource "random_id" "webhook" {
  byte_length = "64"
}

resource "aws_ssm_parameter" "webhook" {
  count = var.atlantis_bitbucket_user_token != "" ? 0 : 1

  name  = var.webhook_ssm_parameter_name
  type  = "SecureString"
  value = random_id.webhook.hex
}

resource "aws_ssm_parameter" "atlantis_github_user_token" {
  count = var.atlantis_github_user_token != "" ? 1 : 0

  name  = var.atlantis_github_user_token_ssm_parameter_name
  type  = "SecureString"
  value = var.atlantis_github_user_token
}

resource "aws_ssm_parameter" "atlantis_gitlab_user_token" {
  count = var.atlantis_gitlab_user_token != "" ? 1 : 0

  name  = var.atlantis_gitlab_user_token_ssm_parameter_name
  type  = "SecureString"
  value = var.atlantis_gitlab_user_token
}

resource "aws_ssm_parameter" "atlantis_bitbucket_user_token" {
  count = var.atlantis_bitbucket_user_token != "" ? 1 : 0

  name  = var.atlantis_bitbucket_user_token_ssm_parameter_name
  type  = "SecureString"
  value = var.atlantis_bitbucket_user_token
}

###################
# VPC
###################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v2.5.0"

  create_vpc = var.vpc_id == ""

  name = var.name

  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

###################
# ALB
###################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v4.0.0"

  load_balancer_name = var.name

  vpc_id          = local.vpc_id
  subnets         = local.public_subnet_ids
  security_groups = flatten([module.alb_https_sg.this_security_group_id, module.alb_http_sg.this_security_group_id, var.security_group_ids])

  logging_enabled     = var.alb_logging_enabled
  log_bucket_name     = var.alb_log_bucket_name
  log_location_prefix = var.alb_log_location_prefix

  https_listeners = [
    {
      port            = 443
      certificate_arn = var.certificate_arn == "" ? module.acm.this_acm_certificate_arn : var.certificate_arn
    },
  ]

  https_listeners_count = 1

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    },
  ]

  http_tcp_listeners_count = 1

  target_groups = [
    {
      name                 = var.name
      backend_protocol     = "HTTP"
      backend_port         = var.atlantis_port
      target_type          = "ip"
      deregistration_delay = 10
    },
  ]

  target_groups_count = 1

  tags = local.tags
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = module.alb.http_tcp_listener_arns[0]

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

###################
# Security groups
###################
module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v3.0.1"

  name        = "${var.name}-alb-https"
  vpc_id      = local.vpc_id
  description = "Security group with HTTPS ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = var.alb_ingress_cidr_blocks

  tags = local.tags
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "v3.0.1"

  name        = "${var.name}-alb-http"
  vpc_id      = local.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = var.alb_ingress_cidr_blocks

  tags = local.tags
}

module "atlantis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v3.0.1"

  name        = var.name
  vpc_id      = local.vpc_id
  description = "Security group with open port for Atlantis (${var.atlantis_port}) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = var.atlantis_port
      to_port                  = var.atlantis_port
      protocol                 = "tcp"
      description              = "Atlantis"
      source_security_group_id = module.alb_https_sg.this_security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}

###################
# ACM (SSL certificate)
###################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "v2.4.0"

  create_certificate = var.certificate_arn == ""

  domain_name = var.acm_certificate_domain_name == "" ? join(".", [var.name, var.route53_zone_name]) : var.acm_certificate_domain_name

  zone_id = var.certificate_arn == "" ? element(concat(data.aws_route53_zone.this.*.id, [""]), 0) : ""

  tags = local.tags
}

###################
# Route53 record
###################
resource "aws_route53_record" "atlantis" {
  count = var.create_route53_record ? 1 : 0

  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.load_balancer_zone_id
    evaluate_target_health = true
  }
}

###################
# ECS
###################
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v2.0.0"

  name = var.name
}

data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.name}-ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = length(var.policies_arn)

  role       = aws_iam_role.ecs_task_execution.id
  policy_arn = element(var.policies_arn, count.index)
}

// ref: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
data "aws_iam_policy_document" "ecs_task_access_secrets" {
  statement {
    effect = "Allow"

    resources = [
      "arn:${var.aws_ssm_path}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.webhook_ssm_parameter_name}",
      "arn:${var.aws_ssm_path}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.atlantis_github_user_token_ssm_parameter_name}",
      "arn:${var.aws_ssm_path}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.atlantis_gitlab_user_token_ssm_parameter_name}",
      "arn:${var.aws_ssm_path}:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.atlantis_bitbucket_user_token_ssm_parameter_name}",
    ]

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_access_secrets_with_kms" {
  count = var.ssm_kms_key_arn == "" ? 0 : 1

  source_json = data.aws_iam_policy_document.ecs_task_access_secrets.json

  statement {
    sid       = "AllowKMSDecrypt"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [var.ssm_kms_key_arn]
  }
}

resource "aws_iam_role_policy" "ecs_task_access_secrets" {
  count = var.atlantis_github_user_token != "" || var.atlantis_gitlab_user_token != "" || var.atlantis_bitbucket_user_token != "" ? 1 : 0

  name = "ECSTaskAccessSecretsPolicy"

  role = aws_iam_role.ecs_task_execution.id

  policy = element(
    compact(
      concat(
        data.aws_iam_policy_document.ecs_task_access_secrets_with_kms.*.json,
        data.aws_iam_policy_document.ecs_task_access_secrets.*.json,
      ),
    ),
    0,
  )
}

module "container_definition_github_gitlab" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.15.0"

  container_name  = var.name
  container_image = local.atlantis_image

  container_cpu                = var.ecs_task_cpu
  container_memory             = var.ecs_task_memory
  container_memory_reservation = var.container_memory_reservation

  port_mappings = [
    {
      containerPort = var.atlantis_port
      hostPort      = var.atlantis_port
      protocol      = "tcp"
    },
  ]

  log_options = {
    "awslogs-region"        = data.aws_region.current.name
    "awslogs-group"         = aws_cloudwatch_log_group.atlantis.name
    "awslogs-stream-prefix" = "ecs"
  }

  environment = concat(
    local.container_definition_environment,
    var.custom_environment_variables,
  )

  secrets = concat(
    local.container_definition_secrets_1,
    local.container_definition_secrets_2,
    var.custom_environment_secrets,
  )
}

module "container_definition_bitbucket" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.15.0"

  container_name  = var.name
  container_image = local.atlantis_image

  container_cpu                = var.ecs_task_cpu
  container_memory             = var.ecs_task_memory
  container_memory_reservation = var.container_memory_reservation

  port_mappings = [
    {
      containerPort = var.atlantis_port
      hostPort      = var.atlantis_port
      protocol      = "tcp"
    },
  ]

  log_options = {
    "awslogs-region"        = data.aws_region.current.name
    "awslogs-group"         = aws_cloudwatch_log_group.atlantis.name
    "awslogs-stream-prefix" = "ecs"
  }

  environment = concat(
    local.container_definition_environment,
    var.custom_environment_variables,
  )

  secrets = concat(
    local.container_definition_secrets_1,
    var.custom_environment_secrets,
  )
}

resource "aws_ecs_task_definition" "atlantis" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = local.container_definitions
}

data "aws_ecs_task_definition" "atlantis" {
  task_definition = var.name

  depends_on = [aws_ecs_task_definition.atlantis]
}

resource "aws_ecs_service" "atlantis" {
  name    = var.name
  cluster = module.ecs.this_ecs_cluster_id
  task_definition = "${data.aws_ecs_task_definition.atlantis.family}:${max(
    aws_ecs_task_definition.atlantis.revision,
    data.aws_ecs_task_definition.atlantis.revision,
  )}"
  desired_count                      = var.ecs_service_desired_count
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = var.ecs_service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent

  network_configuration {
    subnets          = local.private_subnet_ids
    security_groups  = [module.atlantis_sg.this_security_group_id]
    assign_public_ip = var.ecs_service_assign_public_ip
  }

  load_balancer {
    container_name   = var.name
    container_port   = var.atlantis_port
    target_group_arn = element(module.alb.target_group_arns, 0)
  }
}

###################
# Cloudwatch logs
###################
resource "aws_cloudwatch_log_group" "atlantis" {
  name              = var.name
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = local.tags
}

