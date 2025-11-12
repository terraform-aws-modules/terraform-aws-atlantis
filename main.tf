locals {
  # Atlantis
  atlantis_url = "https://${try(
    coalesce(
      var.atlantis.fqdn,
      try(module.alb.route53_records["A"].fqdn, null),
      module.alb.dns_name,
    ),
  "")}"
}

################################################################################
# ALB
################################################################################

locals {
  route53_records = {
    A = {
      name    = try(coalesce(var.route53_record_name, var.name), "")
      type    = "A"
      zone_id = var.route53_zone_id
    }
    AAAA = {
      name    = try(coalesce(var.route53_record_name, var.name), "")
      type    = "AAAA"
      zone_id = var.route53_zone_id
    }
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.2.0"

  region = var.region
  create = var.create && var.create_alb

  # Load balancer
  access_logs                      = var.alb.access_logs
  connection_logs                  = var.alb.connection_logs
  drop_invalid_header_fields       = var.alb.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.alb.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.alb.enable_deletion_protection
  enable_http2                     = var.alb.enable_http2
  enable_waf_fail_open             = var.alb.enable_waf_fail_open
  enable_zonal_shift               = var.alb.enable_zonal_shift
  idle_timeout                     = var.alb.idle_timeout
  internal                         = var.alb.internal
  ip_address_type                  = var.alb.ip_address_type
  load_balancer_type               = "application"
  name                             = try(coalesce(var.alb.name, var.name), "")
  preserve_host_header             = var.alb.preserve_host_header
  security_groups                  = var.alb.security_groups
  subnets                          = var.alb.subnet_ids

  # Listener(s)
  default_port     = var.alb.default_port
  default_protocol = var.alb.default_protocol
  listeners = merge(
    {
      http-https-redirect = {
        port     = 80
        protocol = "HTTP"

        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }

      https = merge(
        {
          port            = 443
          protocol        = "HTTPS"
          ssl_policy      = var.alb.https_listener_ssl_policy
          certificate_arn = var.create_certificate ? module.acm.acm_certificate_arn : var.certificate_arn
        },
        var.alb.https_default_action,
        var.alb.https_listener,
      )
    },
    var.alb.listeners
  )

  # Target group(s)
  target_groups = merge(
    {
      atlantis = {
        name                 = var.name
        protocol             = "HTTP"
        port                 = var.atlantis.port
        create_attachment    = false
        target_type          = "ip"
        deregistration_delay = 10

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
    },
    var.alb.target_groups
  )

  # Security group
  create_security_group          = var.alb.create_security_group
  security_group_name            = try(coalesce(var.alb.security_group_name, var.name), "")
  security_group_use_name_prefix = var.alb.security_group_use_name_prefix
  security_group_description     = var.alb.security_group_description
  vpc_id                         = var.vpc_id
  security_group_ingress_rules   = var.alb.security_group_ingress_rules
  security_group_egress_rules    = var.alb.security_group_egress_rules
  security_group_tags            = var.alb.security_group_tags

  # Route53 record(s)
  route53_records = merge(
    { for k, v in local.route53_records : k => v if var.create_route53_records },
    var.alb.route53_records
  )

  # WAF
  associate_web_acl = var.alb.associate_web_acl
  web_acl_arn       = var.alb.web_acl_arn

  tags = merge(
    var.tags,
    var.alb.tags,
  )
}

################################################################################
# ACM
################################################################################

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.1.1"

  region             = var.region
  create_certificate = var.create && var.create_certificate && var.create_alb

  domain_name          = var.certificate_domain_name
  validate_certificate = var.validate_certificate
  validation_method    = "DNS"
  zone_id              = var.route53_zone_id

  tags = var.tags
}

################################################################################
# ECS
################################################################################

locals {
  mount_path = "/home/atlantis"
  mount_points = var.enable_efs ? [{
    containerPath = local.mount_path
    sourceVolume  = "efs"
    readOnly      = false
  }] : var.atlantis.mountPoints
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "6.7.0"

  region = var.region
  create = var.create && var.create_cluster

  # Cluster
  name          = try(coalesce(var.cluster.name, var.name))
  configuration = var.cluster.configuration
  setting       = var.cluster.setting

  # Cloudwatch log group
  create_cloudwatch_log_group            = var.cluster.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cluster.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = var.cluster.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_class             = var.cluster.cloudwatch_log_group_class
  cloudwatch_log_group_tags              = var.cluster.cloudwatch_log_group_tags

  # Capacity providers
  default_capacity_provider_strategy = var.cluster.default_capacity_provider_strategy

  tags = var.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "6.7.0"

  region = var.region
  create = var.create

  # Service
  capacity_provider_strategy         = var.service.capacity_provider_strategy
  cluster_arn                        = var.create_cluster && var.create ? module.ecs_cluster.arn : var.cluster_arn
  deployment_circuit_breaker         = var.service.deployment_circuit_breaker
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  desired_count                      = 1
  enable_ecs_managed_tags            = var.service.enable_ecs_managed_tags
  enable_execute_command             = false
  force_new_deployment               = var.service.force_new_deployment
  health_check_grace_period_seconds  = var.service.health_check_grace_period_seconds
  launch_type                        = var.service.launch_type
  load_balancer = merge(
    {
      service = {
        target_group_arn = var.create && var.create_alb ? module.alb.target_groups["atlantis"].arn : var.alb_target_group_arn
        container_name   = "atlantis"
        container_port   = var.atlantis.port
      }
    },
    var.service.load_balancer
  )
  name                  = try(coalesce(var.service.name, var.name))
  assign_public_ip      = var.service.assign_public_ip
  security_group_ids    = var.service.security_group_ids
  subnet_ids            = var.service.subnet_ids
  platform_version      = var.service.platform_version
  propagate_tags        = var.service.propagate_tags
  timeouts              = var.service.timeouts
  triggers              = var.service.triggers
  wait_for_steady_state = var.service.wait_for_steady_state

  # Service IAM role
  create_iam_role               = var.service.create_iam_role
  iam_role_arn                  = var.service.iam_role_arn
  iam_role_name                 = var.service.iam_role_name
  iam_role_use_name_prefix      = var.service.iam_role_use_name_prefix
  iam_role_path                 = var.service.iam_role_path
  iam_role_description          = var.service.iam_role_description
  iam_role_permissions_boundary = var.service.iam_role_permissions_boundary
  iam_role_tags                 = var.service.iam_role_tags
  iam_role_statements           = var.service.iam_role_statements

  # Task definition
  create_task_definition = var.service.create_task_definition
  task_definition_arn    = var.service.task_definition_arn
  container_definitions = merge(
    {
      atlantis = {
        command               = var.atlantis.command
        cpu                   = var.atlantis.cpu
        dependsOn             = var.atlantis.dependsOn
        disableNetworking     = var.atlantis.disableNetworking
        dnsSearchDomains      = var.atlantis.dnsSearchDomains
        dnsServers            = var.atlantis.dnsServers
        dockerLabels          = var.atlantis.dockerLabels
        dockerSecurityOptions = var.atlantis.dockerSecurityOptions
        entrypoint            = var.atlantis.entrypoint
        environment = concat(
          [
            {
              name  = "ATLANTIS_PORT"
              value = var.atlantis.port
            },
            {
              name  = "ATLANTIS_ATLANTIS_URL"
              value = local.atlantis_url
            },
          ],
          var.atlantis.environment
        )
        environmentFiles      = var.atlantis.environmentFiles
        essential             = true
        extraHosts            = var.atlantis.extraHosts
        firelensConfiguration = var.atlantis.firelensConfiguration
        fqdn                  = var.atlantis.fqdn
        healthCheck           = var.atlantis.healthCheck
        hostname              = var.atlantis.hostname
        image                 = var.atlantis.image
        linuxParameters       = var.atlantis.linuxParameters
        logConfiguration      = var.atlantis.logConfiguration
        memory                = var.atlantis.memory
        memoryReservation     = var.atlantis.memoryReservation
        mountPoints           = local.mount_points
        name                  = "atlantis"
        portMappings = [{
          name          = "atlantis"
          containerPort = var.atlantis.port
          protocol      = "tcp"
        }]
        privileged             = var.atlantis.privileged
        readonlyRootFilesystem = var.atlantis.readonlyRootFilesystem
        repositoryCredentials  = var.atlantis.repositoryCredentials
        resourceRequirements   = var.atlantis.resourceRequirements
        restartPolicy          = var.atlantis.restartPolicy
        secrets                = var.atlantis.secrets
        startTimeout           = var.atlantis.startTimeout
        stopTimeout            = var.atlantis.stopTimeout
        user                   = try(coalesce(var.atlantis.user, "${var.atlantis.uid}:${var.atlantis.gid}"))
        versionConsistency     = "disabled"
        volumesFrom            = var.atlantis.volumesFrom
        workingDirectory       = var.atlantis.workingDirectory

        # CloudWatch Log Group
        service                                = try(coalesce(var.service.name, var.name))
        enable_cloudwatch_logging              = var.atlantis.enable_cloudwatch_logging
        create_cloudwatch_log_group            = var.atlantis.create_cloudwatch_log_group
        cloudwatch_log_group_use_name_prefix   = var.atlantis.cloudwatch_log_group_use_name_prefix
        cloudwatch_log_group_retention_in_days = var.atlantis.cloudwatch_log_group_retention_in_days
        cloudwatch_log_group_class             = var.atlantis.cloudwatch_log_group_class
        cloudwatch_log_group_kms_key_id        = var.atlantis.cloudwatch_log_group_kms_key_id
      },
    },
    var.service.container_definitions
  )
  cpu                      = var.service.cpu
  ephemeral_storage        = var.service.ephemeral_storage
  family                   = var.service.family
  memory                   = var.service.memory
  network_mode             = "awsvpc"
  requires_compatibilities = var.service.requires_compatibilities
  runtime_platform         = var.service.runtime_platform
  track_latest             = true
  volume = merge(
    { for k, v in {
      efs = {
        efs_volume_configuration = {
          file_system_id     = module.efs.id
          transit_encryption = "ENABLED"
          authorization_config = {
            access_point_id = try(module.efs.access_points["atlantis"].id, "")
            iam             = "ENABLED"
          }
        }
      }
    } : k => v if var.enable_efs },
    var.service.volume
  )
  task_tags = var.service.task_tags

  # Task execution IAM role
  create_task_exec_iam_role               = var.service.create_task_exec_iam_role
  task_exec_iam_role_arn                  = var.service.task_exec_iam_role_arn
  task_exec_iam_role_name                 = var.service.task_exec_iam_role_name
  task_exec_iam_role_use_name_prefix      = var.service.task_exec_iam_role_use_name_prefix
  task_exec_iam_role_path                 = var.service.task_exec_iam_role_path
  task_exec_iam_role_description          = var.service.task_exec_iam_role_description
  task_exec_iam_role_permissions_boundary = var.service.task_exec_iam_role_permissions_boundary
  task_exec_iam_role_tags                 = var.service.task_exec_iam_role_tags
  task_exec_iam_role_policies             = var.service.task_exec_iam_role_policies
  task_exec_iam_role_max_session_duration = var.service.task_exec_iam_role_max_session_duration

  # Task execution IAM role policy
  create_task_exec_policy  = var.service.create_task_exec_policy
  task_exec_ssm_param_arns = var.service.task_exec_ssm_param_arns
  task_exec_secret_arns    = var.service.task_exec_secret_arns
  task_exec_iam_statements = var.service.task_exec_iam_statements

  # Tasks - IAM role
  create_tasks_iam_role               = var.service.create_tasks_iam_role
  tasks_iam_role_arn                  = var.service.tasks_iam_role_arn
  tasks_iam_role_name                 = var.service.tasks_iam_role_name
  tasks_iam_role_use_name_prefix      = var.service.tasks_iam_role_use_name_prefix
  tasks_iam_role_path                 = var.service.tasks_iam_role_path
  tasks_iam_role_description          = var.service.tasks_iam_role_description
  tasks_iam_role_permissions_boundary = var.service.tasks_iam_role_permissions_boundary
  tasks_iam_role_tags                 = var.service.tasks_iam_role_tags
  tasks_iam_role_policies             = var.service.tasks_iam_role_policies
  tasks_iam_role_statements           = var.service.tasks_iam_role_statements

  # Autoscaling
  # Atlantis only supports a single instance
  enable_autoscaling = false

  # Security Group
  create_security_group          = var.service.create_security_group
  security_group_name            = var.service.security_group_name
  security_group_use_name_prefix = var.service.security_group_use_name_prefix
  security_group_description     = var.service.security_group_description
  security_group_ingress_rules = merge(
    {
      atlantis = {
        from_port                    = var.atlantis.port
        protocol                     = "tcp"
        referenced_security_group_id = var.create_alb ? module.alb.security_group_id : var.alb_security_group_id
      }
    },
    var.service.security_group_ingress_rules
  )
  security_group_egress_rules = merge(
    {
      egress = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  )
  security_group_tags = var.service.security_group_tags

  tags = var.tags
}

################################################################################
# EFS
################################################################################

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "2.0.0"

  region = var.region
  create = var.create && var.enable_efs

  name = try(coalesce(var.efs.name, var.name))

  # File System
  availability_zone_name          = var.efs.availability_zone_name
  creation_token                  = try(coalesce(var.efs.creation_token, var.name))
  performance_mode                = var.efs.performance_mode
  encrypted                       = var.efs.encrypted
  kms_key_arn                     = var.efs.kms_key_arn
  provisioned_throughput_in_mibps = var.efs.provisioned_throughput_in_mibps
  throughput_mode                 = var.efs.throughput_mode
  lifecycle_policy                = var.efs.lifecycle_policy
  protection                      = var.efs.protection

  # File System Policy
  attach_policy                      = var.efs.attach_policy
  bypass_policy_lockout_safety_check = var.efs.bypass_policy_lockout_safety_check
  source_policy_documents            = var.efs.source_policy_documents
  override_policy_documents          = var.efs.override_policy_documents
  policy_statements = merge(
    {
      EFSMountWrite = {
        actions = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
        ]
        principals = [
          {
            type        = "AWS"
            identifiers = [module.ecs_service.tasks_iam_role_arn]
          }
        ]
      }
    },
    var.efs.policy_statements
  )
  deny_nonsecure_transport                  = var.efs.deny_nonsecure_transport
  deny_nonsecure_transport_via_mount_target = var.efs.deny_nonsecure_transport_via_mount_target

  # Mount targets
  mount_targets = var.efs.mount_targets

  # Security Group
  create_security_group          = var.efs.create_security_group
  security_group_name            = try(coalesce(var.efs.security_group_name, "${var.name}-efs-"))
  security_group_use_name_prefix = var.efs.security_group_use_name_prefix
  security_group_description     = var.efs.security_group_description
  security_group_vpc_id          = var.vpc_id
  security_group_ingress_rules = merge(
    {
      atlantis = {
        # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
        description                  = "NFS ingress from Atlantis"
        referenced_security_group_id = module.ecs_service.security_group_id
      }
    },
    var.efs.security_group_ingress_rules
  )

  # Access Point(s)
  access_points = merge(
    {
      atlantis = {
        posix_user = {
          gid = var.atlantis.gid
          uid = var.atlantis.uid
        }
        root_directory = {
          path = local.mount_path
          creation_info = {
            owner_gid   = var.atlantis.gid
            owner_uid   = var.atlantis.uid
            permissions = "0750"
          }
        }
      }
    },
    var.efs.access_points
  )

  # Backup Policy
  create_backup_policy = false
  enable_backup_policy = false

  tags = var.tags
}
