locals {
  # VPC - existing or new?
  vpc_id             = "${var.vpc_id == "" ? module.vpc.vpc_id : var.vpc_id}"
  private_subnet_ids = "${coalescelist(module.vpc.private_subnets, var.private_subnet_ids)}"
  public_subnet_ids  = "${coalescelist(module.vpc.public_subnets, var.public_subnet_ids)}"

  # Atlantis
  atlantis_url        = "https://${coalesce(element(concat(aws_route53_record.atlantis.*.fqdn, list("")), 0), module.alb.dns_name)}"
  atlantis_url_events = "${local.atlantis_url}/events"
  container_definition = "${var.container_definitions == "" ? "${data.template_file.container_definitions.rendered}" : "${var.container_definitions}" }"
  tags = "${var.tags}"
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/templates/atlantis-task.json")}"

  vars {
    name                            = "${var.name}"
    atlantis_image                  = "${var.atlantis_image == "" ? "runatlantis/atlantis:${var.atlantis_version}" : "${var.atlantis_image}" }"
    logs_name                       = "${var.name}"
    logs_region                     = "${var.aws_region}"
    ATLANTIS_ALLOW_REPO_CONFIG      = "${var.allow_repo_config}"
    ATLANTIS_LOG_LEVEL              = "debug"
    ATLANTIS_PORT                   = "4141"
    ATLANTIS_ATLANTIS_URL           = "https://${coalesce(element(concat(aws_route53_record.atlantis.*.fqdn, list("")), 0), module.alb.dns_name)}"
    ATLANTIS_GITLAB_USER            = "${var.atlantis_gitlab_user}"
    ATLANTIS_GITLAB_TOKEN           = "${var.atlantis_gitlab_user_token}"
    ATLANTIS_GITLAB_WEBHOOK_SECRET  = "${var.atlantis_webhook_secret}"
    ATLANTIS_REPO_WHITELIST         = "${join(",", var.atlantis_repo_whitelist)}"
  }
}

resource "random_id" "webhook" {
  byte_length = "64"
}

###################
# Gitlab webhook(s)
###################
module "gitlab_project_hook" {
  source = "../modules/gitlab-repository-webhook"

  create_gitlab_repository_webhook = "${var.create_gitlab_repository_webhook}"

  base_url            = "${var.atlantis_gitlab_base_url}"
  gitlab_token        = "${var.atlantis_gitlab_user_token}"
  gitlab_organization = "${var.gitlab_organization}"

  atlantis_allowed_repo_names = "${var.atlantis_allowed_repo_names}"

  webhook_url    = "${local.atlantis_url_events}"
  webhook_secret = "${random_id.webhook.hex}"
}

###################
# VPC
###################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v1.32.0"

  create_vpc = "${var.vpc_id == ""}"

  name = "${var.name}"

  cidr            = "${var.cidr}"
  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = "${local.tags}"
}

###################
# ALB
###################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v3.4.0"

  load_balancer_name = "${var.name}"

  vpc_id          = "${local.vpc_id}"
  subnets         = ["${local.public_subnet_ids}"]
  security_groups = ["${module.alb_https_sg.this_security_group_id}"]
  logging_enabled = false

  https_listeners = [{
    port            = 443
    certificate_arn = "${var.certificate_arn == "" ? element(concat(aws_acm_certificate_validation.cert.*.certificate_arn, list("")), 0) : var.certificate_arn}"
  }]

  https_listeners_count = 1

  target_groups = [{
    name                 = "${var.name}"
    backend_protocol     = "HTTP"
    backend_port         = 4141
    target_type          = "ip"
    deregistration_delay = 10
  }]

  target_groups_count = 1

  tags = "${local.tags}"
}

###################
# Security groups
###################
module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v2.0.0"

  name        = "${var.name}-alb"
  vpc_id      = "${local.vpc_id}"
  description = "Security group with HTTPS ports open for everybody (IPv4 CIDR), egress ports are all world open"

  ingress_cidr_blocks = "${var.alb_ingress_cidr_blocks}"

  tags = "${local.tags}"
}

module "atlantis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v2.0.0"

  name        = "${var.name}"
  vpc_id      = "${local.vpc_id}"
  description = "Security group with open port for Atlantis (4141) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 4141
      to_port                  = 4141
      protocol                 = "tcp"
      description              = "Atlantis"
      source_security_group_id = "${module.alb_https_sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = "${local.tags}"
}

###################
# ACM (SSL certificate)
###################
resource "aws_acm_certificate" "cert" {
  count = "${var.certificate_arn == "" ? 1 : 0}"

  domain_name       = "${var.acm_certificate_domain_name == "" ? join(".", list(var.name, var.route53_zone_name)) : var.acm_certificate_domain_name}"
  validation_method = "DNS"

  tags = "${local.tags}"
}

data "aws_route53_zone" "this" {
  count = "${var.create_route53_record}"

  name         = "${var.route53_zone_name}"
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  count = "${var.certificate_arn == "" ? 1 : 0}"

  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.this.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 3600
}

resource "aws_acm_certificate_validation" "cert" {
  count = "${var.certificate_arn == "" ? 1 : 0}"

  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_route53_record" "atlantis" {
  count = "${var.create_route53_record}"

  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.name}"
  type    = "A"

  alias {
    name                   = "${module.alb.dns_name}"
    zone_id                = "${module.alb.load_balancer_zone_id}"
    evaluate_target_health = true
  }
}

###################
# ECS
###################
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v1.0.0"

  name = "${var.name}"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name}-ecs_task_execution"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = "${length(var.policies_arn)}"

  role       = "${aws_iam_role.ecs_task_execution.id}"
  policy_arn = "${element(var.policies_arn, count.index)}"
}

resource "aws_ecs_task_definition" "atlantis" {
  family                   = "${var.name}"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task_execution.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024

  container_definitions = "${local.container_definition}"
  
}

data "aws_ecs_task_definition" "atlantis-data" {
  task_definition = "${var.name}"
  depends_on      = ["aws_ecs_task_definition.atlantis"]
}

resource "aws_ecs_service" "atlantis" {
  name                               = "${var.name}"
  cluster                            = "${module.ecs.this_ecs_cluster_id}"
  task_definition                    = "${data.aws_ecs_task_definition.atlantis-data.family}:${max("${aws_ecs_task_definition.atlantis.revision}", "${data.aws_ecs_task_definition.atlantis-data.revision}")}"
  desired_count                      = "${var.desired_num_tasks}"
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  network_configuration {
    subnets          = ["${local.private_subnet_ids}"]
    security_groups  = ["${module.atlantis_sg.this_security_group_id}"]
    assign_public_ip = "${var.ecs_service_assign_public_ip}"
  }

  load_balancer {
    container_name   = "${var.name}"
    container_port   = 4141
    target_group_arn = "${element(module.alb.target_group_arns, 0)}"
  }
}

###################
# Cloudwatch logs
###################
resource "aws_cloudwatch_log_group" "atlantis" {
  name              = "${var.name}"
  retention_in_days = "${var.cloudwatch_log_retention_in_days}"

  tags = "${local.tags}"
}
