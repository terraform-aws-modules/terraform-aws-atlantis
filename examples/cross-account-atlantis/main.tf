terraform {
  required_version = "~>0.15"

  backend "s3" {
    bucket = "secndwatch-remote-state-development"
    region = "us-east-1"
    key    = "terraform-aws-atlantis"
  }

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

##############################################################
# Data sources for existing resources
##############################################################

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "current" {}

##############################################################
# Atlantis Service
##############################################################

module "atlantis" {
  source = "../../"

  name = "atlantis"

  cidr            = "10.2.50.0/24"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  public_subnets  = ["10.2.50.0/28", "10.2.50.32/28", "10.2.50.64/28", "10.2.50.96/28", "10.2.50.128/28", "10.2.50.160/28"]
  private_subnets = ["10.2.50.16/28", "10.2.50.48/28", "10.2.50.80/28", "10.2.50.112/28", "10.2.50.144/28", "10.2.50.176/28"]

  route53_zone_name = var.domain_name

  # ECS
  ecs_service_platform_version = "LATEST"
  ecs_container_insights       = true
  ecs_task_cpu                 = 512
  ecs_task_memory              = 1024
  container_memory_reservation = 256
  ecs_fargate_spot             = true
  policies_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/PowerUserAccess",
  ]

  entrypoint        = ["docker-entrypoint.sh"]
  command           = ["server"]
  working_directory = "/tmp"
  docker_labels = {
    "org.opencontainers.image.title"       = "Atlantis"
    "org.opencontainers.image.description" = "A self-hosted golang application that listens for Terraform pull request events via webhooks."
    "org.opencontainers.image.url"         = "https://github.com/runatlantis/atlantis/blob/master/Dockerfile"
  }
  start_timeout = 30
  stop_timeout  = 30

  user                     = "atlantis"
  readonly_root_filesystem = false # atlantis currently mutable access to root filesystem
  ulimits = [{
    name      = "nofile"
    softLimit = 4096
    hardLimit = 16384
  }]

  # Atlantis
  atlantis_github_user           = "aiell0"
  atlantis_github_user_token     = var.github_user_token
  atlantis_github_webhook_secret = var.github_webhook_secret
  atlantis_repo_whitelist        = var.atlantis_repo_whitelist

  # ALB access
  alb_ingress_cidr_blocks         = ["0.0.0.0/0"]
  alb_logging_enabled             = true
  alb_log_bucket_name             = module.atlantis_access_log_bucket.s3_bucket_id
  alb_log_location_prefix         = "atlantis-alb"
  alb_listener_ssl_policy_default = "ELBSecurityPolicy-TLS-1-2-2017-01"

  allow_unauthenticated_access = true
  allow_github_webhooks        = true
  allow_repo_config            = true

  s3_state_buckets = var.s3_state_buckets
}

################################################################################
# ALB Access Log Bucket + Policy
################################################################################
module "atlantis_access_log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = ">= 1.9"

  bucket = "${data.aws_caller_identity.current.account_id}-atlantis-access-logs-${data.aws_region.current.name}"

  attach_policy = true
  policy        = data.aws_iam_policy_document.atlantis_access_log_bucket_policy.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

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
