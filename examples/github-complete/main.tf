provider "aws" {
  region = local.region
}

locals {
  name   = "github-complete"
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
  source = "../../"

  name = local.name

  # VPC
  cidr            = "10.20.0.0/16"
  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

  # EFS
  enable_ephemeral_storage = true

  # ECS
  ecs_service_platform_version = "LATEST"
  ecs_container_insights       = true
  ecs_task_cpu                 = 512
  ecs_task_memory              = 1024
  container_memory_reservation = 256
  container_cpu                = 512
  container_memory             = 1024

  runtime_platform = {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  entrypoint        = ["docker-entrypoint.sh"]
  command           = ["server"]
  working_directory = "/tmp"
  docker_labels = {
    "org.opencontainers.image.title"       = "Atlantis"
    "org.opencontainers.image.description" = "A self-hosted golang application that listens for Terraform pull request events via webhooks."
    "org.opencontainers.image.url"         = "https://github.com/runatlantis/atlantis/pkgs/container/atlantis"
  }
  start_timeout = 30
  stop_timeout  = 30

  readonly_root_filesystem = false # atlantis currently mutable access to root filesystem
  ulimits = [{
    name      = "nofile"
    softLimit = 4096
    hardLimit = 16384
  }]

  # DNS
  route53_zone_name = var.domain

  # Trusted roles
  trusted_principals = ["ssm.amazonaws.com"]

  # IAM role options
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cloud/developer-boundary-policy"
  path                 = "/delegatedadmin/developer/"

  # Bootstrapping a new Github App
  atlantis_github_user       = var.bootstrap_github_app ? "fake" : ""
  atlantis_github_user_token = var.bootstrap_github_app ? "fake" : ""

  # Atlantis w/ GitHub app
  ################################################################################
  # Suggestion: instead of allocating the values of the atlantis_github_app_key
  # and atlantis_github_webhook_secret in the tfvars file,it is suggested to
  # upload the values in the AWS Parameter Store of the atlantis account and
  # call the values via the data source function
  # (e.g. data.aws_ssm_parameter.ghapp_key.value) for security reasons.
  ################################################################################

  atlantis_github_app_id         = var.bootstrap_github_app ? "" : var.github_app_id
  atlantis_github_app_key        = var.bootstrap_github_app ? "" : var.github_app_key
  atlantis_github_webhook_secret = var.bootstrap_github_app ? "" : var.github_webhook_secret
  atlantis_repo_allowlist        = [for repo in var.github_repo_names : "github.com/${var.github_owner}/${repo}"]

  # ALB access
  alb_ingress_cidr_blocks              = var.alb_ingress_cidr_blocks
  alb_logging_enabled                  = true
  alb_log_bucket_name                  = module.atlantis_access_log_bucket.s3_bucket_id
  alb_log_location_prefix              = "atlantis-alb"
  alb_listener_ssl_policy_default      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  alb_drop_invalid_header_fields       = true
  alb_enable_cross_zone_load_balancing = true

  allow_unauthenticated_access = true
  allow_github_webhooks        = true
  allow_repo_config            = true

  # Extra container definitions
  extra_container_definitions = [
    {
      name      = "log-router"
      image     = "amazon/aws-for-fluent-bit:latest"
      essential = true

      firelens_configuration = {
        type = "fluentbit"

        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group         = "firelens-container",
            awslogs-region        = local.region,
            awslogs-create-group  = true,
            awslogs-stream-prefix = "firelens"
          }
        }
      }
    }
  ]

  tags = local.tags
}

################################################################################
# ALB Access Log Bucket + Policy
################################################################################
module "atlantis_access_log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "atlantis-access-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  attach_policy = true
  policy        = data.aws_iam_policy_document.atlantis_access_log_bucket_policy.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

  tags = local.tags

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "all"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = 90
      }

      noncurrent_version_expiration = {
        days = 30
      }
    },
  ]
}

data "aws_iam_policy_document" "atlantis_access_log_bucket_policy" {
  statement {
    sid     = "LogsLogDeliveryWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${module.atlantis_access_log_bucket.s3_bucket_arn}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
        data.aws_elb_service_account.current.arn,
      ]
    }
  }

  statement {
    sid     = "AWSLogDeliveryWrite"
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${module.atlantis_access_log_bucket.s3_bucket_arn}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    sid     = "AWSLogDeliveryAclCheck"
    effect  = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [
      module.atlantis_access_log_bucket.s3_bucket_arn
    ]

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }
  }
}

