locals {
  # Atlantis
  atlantis_url = "https://${try(coalesce(
    try(var.atlantis.fqdn, module.alb.route53_records["A"].fqdn, null),
    module.alb.dns_name,
  ), "")}"

  atlantis_port = try(var.atlantis.port, 4141)
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
  version = "9.17.0"

  create = var.create && var.create_alb

  # Load balancer
  access_logs                                 = lookup(var.alb, "access_logs", {})
  customer_owned_ipv4_pool                    = try(var.alb.customer_owned_ipv4_pool, null)
  desync_mitigation_mode                      = try(var.alb.desync_mitigation_mode, null)
  dns_record_client_routing_policy            = try(var.alb.dns_record_client_routing_policy, null)
  drop_invalid_header_fields                  = try(var.alb.drop_invalid_header_fields, true)
  enable_cross_zone_load_balancing            = try(var.alb.enable_cross_zone_load_balancing, true)
  enable_deletion_protection                  = try(var.alb.enable_deletion_protection, true)
  enable_http2                                = try(var.alb.enable_http2, null)
  enable_tls_version_and_cipher_suite_headers = try(var.alb.enable_tls_version_and_cipher_suite_headers, null)
  enable_waf_fail_open                        = try(var.alb.enable_waf_fail_open, null)
  enable_xff_client_port                      = try(var.alb.enable_xff_client_port, null)
  idle_timeout                                = try(var.alb.idle_timeout, null)
  internal                                    = try(var.alb.internal, false)
  ip_address_type                             = try(var.alb.ip_address_type, null)
  load_balancer_type                          = try(var.alb.load_balancer_type, "application")
  name                                        = try(var.alb.name, var.name)
  preserve_host_header                        = try(var.alb.preserve_host_header, null)
  security_groups                             = try(var.alb.security_groups, [])
  subnets                                     = try(var.alb.subnets, var.alb_subnets)
  xff_header_processing_mode                  = try(var.alb.xff_header_processing_mode, null)
  timeouts                                    = try(var.alb.timeouts, {})

  # Listener(s)
  default_port     = try(var.alb.default_port, 80)
  default_protocol = try(var.alb.default_protocol, "HTTP")
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
          ssl_policy      = try(var.alb.https_listener_ssl_policy, "ELBSecurityPolicy-TLS13-1-2-Res-2021-06")
          certificate_arn = var.create_certificate ? module.acm.acm_certificate_arn : var.certificate_arn
        },
        var.alb_https_default_action,
        lookup(var.alb, "https_listener", {})
      )
    },
    lookup(var.alb, "listeners", {})
  )

  # Target group(s)
  target_groups = merge(
    {
      atlantis = {
        name                              = var.name
        protocol                          = "HTTP"
        port                              = local.atlantis_port
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
    },
    lookup(var.alb, "target_groups", {})
  )

  # Security group
  create_security_group          = try(var.alb.create_security_group, true)
  security_group_name            = try(var.alb.security_group_name, var.name)
  security_group_use_name_prefix = try(var.alb.security_group_use_name_prefix, true)
  security_group_description     = try(var.alb.security_group_description, null)
  vpc_id                         = var.vpc_id
  security_group_ingress_rules = lookup(var.alb, "security_group_ingress_rules",
    {
      http = {
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      }
      https = {
        from_port   = 443
        to_port     = 443
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  )
  security_group_egress_rules = lookup(var.alb, "security_group_egress_rules",
    {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  )
  security_group_tags = try(var.alb.security_group_tags, {})

  # Route53 record(s)
  route53_records = merge(
    { for k, v in local.route53_records : k => v if var.create_route53_records },
    lookup(var.alb, "route53_records", {})
  )

  # WAF
  associate_web_acl = try(var.alb.associate_web_acl, false)
  web_acl_arn       = try(var.alb.web_acl_arn, null)

  tags = merge(
    try(var.alb.tags, {}),
    var.tags
  )
}

################################################################################
# ACM
################################################################################

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.1.0"

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
  }] : try(var.atlantis.mountPoints, [])

  # Ref https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/383
  deployment_maximum_percent         = var.enable_efs ? 100 : 200
  deployment_minimum_healthy_percent = var.enable_efs ? 0 : 66
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "6.1.1"

  create = var.create && var.create_cluster

  # Cluster
  name          = try(var.cluster.name, var.name)
  configuration = try(var.cluster.configuration, {})
  setting = try(var.cluster.settings, [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ])

  # Cloudwatch log group
  create_cloudwatch_log_group            = try(var.cluster.create_cloudwatch_log_group, true)
  cloudwatch_log_group_retention_in_days = try(var.cluster.cloudwatch_log_group_retention_in_days, 90)
  cloudwatch_log_group_kms_key_id        = try(var.cluster.cloudwatch_log_group_kms_key_id, null)
  cloudwatch_log_group_tags              = try(var.cluster.cloudwatch_log_group_tags, {})

  # Capacity providers
  default_capacity_provider_strategy = try(var.cluster.default_capacity_provider_strategy, {})

  tags = var.tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "6.1.1"

  create = var.create

  # Service
  ignore_task_definition_changes     = try(var.service.ignore_task_definition_changes, false)
  alarms                             = try(var.service.alarms, null)
  capacity_provider_strategy         = var.service.capacity_provider_strategy
  cluster_arn                        = var.create_cluster && var.create ? module.ecs_cluster.arn : var.cluster_arn
  deployment_controller              = var.service.deployment_controller
  deployment_maximum_percent         = try(var.service.deployment_maximum_percent, local.deployment_maximum_percent)
  deployment_minimum_healthy_percent = try(var.service.deployment_minimum_healthy_percent, local.deployment_minimum_healthy_percent)
  desired_count                      = try(var.service.desired_count, 1)
  enable_ecs_managed_tags            = try(var.service.enable_ecs_managed_tags, true)
  enable_execute_command             = try(var.service.enable_execute_command, false)
  force_new_deployment               = try(var.service.force_new_deployment, true)
  health_check_grace_period_seconds  = var.service.health_check_grace_period_seconds
  launch_type                        = try(var.service.launch_type, "FARGATE")
  load_balancer = merge(
    {
      service = {
        target_group_arn = var.create_alb && var.create ? module.alb.target_groups["atlantis"].arn : var.alb_target_group_arn
        container_name   = "atlantis"
        container_port   = local.atlantis_port
      }
    },
    lookup(var.service, "load_balancer", {})
  )
  name                          = try(var.service.name, var.name)
  assign_public_ip              = try(var.service.assign_public_ip, false)
  security_group_ids            = try(var.service.security_group_ids, [])
  subnet_ids                    = try(var.service.subnet_ids, var.service_subnets)
  ordered_placement_strategy    = var.service.ordered_placement_strategy
  placement_constraints         = var.service.placement_constraints
  platform_version              = var.service.platform_version
  propagate_tags                = var.service.propagate_tags
  scheduling_strategy           = var.service.scheduling_strategy
  service_connect_configuration = var.service.service_connect_configuration
  service_registries            = var.service.service_registries
  timeouts                      = var.service.timeouts
  triggers                      = var.service.triggers
  wait_for_steady_state         = var.service.wait_for_steady_state

  # Service IAM role
  create_iam_role               = try(var.service.create_iam_role, true)
  iam_role_arn                  = var.service.iam_role_arn
  iam_role_name                 = var.service.iam_role_name
  iam_role_use_name_prefix      = try(var.service.iam_role_use_name_prefix, true)
  iam_role_path                 = var.service.iam_role_path
  iam_role_description          = var.service.iam_role_description
  iam_role_permissions_boundary = var.service.iam_role_permissions_boundary
  iam_role_tags                 = try(var.service.iam_role_tags, {})
  iam_role_statements           = lookup(var.service, "iam_role_statements", [])

  # Task definition
  create_task_definition = try(var.service.create_task_definition, true)
  task_definition_arn    = var.service.task_definition_arn
  container_definitions = merge(
    {
      atlantis = {
        command                = try(var.atlantis.command, [])
        cpu                    = try(var.atlantis.cpu, 1024)
        dependsOn              = try(var.atlantis.depends_on, [])
        disableNetworking      = try(var.atlantis.disableNetworking, null)
        dnsSearchDomains       = try(var.atlantis.dnsSearchDomains, [])
        dnsServers             = try(var.atlantis.dnsServers, [])
        dockerLabels           = try(var.atlantis.dockerLabels, {})
        dockerSecurityOptions  = try(var.atlantis.dockerSecurityOptions, [])
        enable_execute_command = try(var.atlantis.enable_execute_command, try(var.service.enable_execute_command, false))
        entryPoint             = try(var.atlantis.entryPoint, [])
        environment = concat(
          [
            {
              name  = "ATLANTIS_PORT"
              value = local.atlantis_port
            },
            {
              name  = "ATLANTIS_ATLANTIS_URL"
              value = local.atlantis_url
            },
          ],
          lookup(var.atlantis, "environment", [])
        )
        environmentFiles      = try(var.atlantis.environmentFiles, [])
        essential             = try(var.atlantis.essential, true)
        extraHosts            = try(var.atlantis.extraHosts, [])
        firelensConfiguration = try(var.atlantis.firelensConfiguration, {})
        healthCheck           = try(var.atlantis.healthCheck, {})
        hostname              = try(var.atlantis.hostname, null)
        image                 = try(var.atlantis.image, "ghcr.io/runatlantis/atlantis:latest")
        interactive           = try(var.atlantis.interactive, false)
        links                 = try(var.atlantis.links, [])
        linuxParameters       = try(var.atlantis.linuxParameters, {})
        logConfiguration      = lookup(var.atlantis, "logConfiguration", {})
        memory                = try(var.atlantis.memory, 2048)
        memoryReservation     = try(var.atlantis.memoryReservation, null)
        mountPoints           = local.mount_points
        name                  = "atlantis"
        portMappings = [{
          name          = "atlantis"
          containerPort = local.atlantis_port
          hostPort      = local.atlantis_port
          protocol      = "tcp"
        }]
        privileged             = try(var.atlantis.privileged, false)
        pseudoTerminal         = try(var.atlantis.pseudoTerminal, false)
        readonlyRootFilesystem = try(var.atlantis.readonlyRootFilesystem, false)
        repositoryCredentials  = try(var.atlantis.repositoryCredentials, {})
        resourceRequirements   = try(var.atlantis.resourceRequirements, [])
        secrets                = try(var.atlantis.secrets, [])
        startTimeout           = try(var.atlantis.startTimeout, 30)
        stopTimeout            = try(var.atlantis.stopTimeout, 120)
        systemControls         = try(var.atlantis.systemControls, [])
        ulimits                = try(var.atlantis.ulimits, [])
        user                   = try(var.atlantis.user, "${var.atlantis_uid}:${var.atlantis_gid}")
        volumesFrom            = try(var.atlantis.volumesFrom, [])
        workingDirectory       = try(var.atlantis.workingDirectory, null)

        # CloudWatch Log Group
        service                                = var.name
        enable_cloudwatch_logging              = try(var.atlantis.enable_cloudwatch_logging, true)
        create_cloudwatch_log_group            = try(var.atlantis.create_cloudwatch_log_group, true)
        cloudwatch_log_group_use_name_prefix   = try(var.atlantis.cloudwatch_log_group_use_name_prefix, true)
        cloudwatch_log_group_retention_in_days = try(var.atlantis.cloudwatch_log_group_retention_in_days, 14)
        cloudwatch_log_group_kms_key_id        = try(var.atlantis.cloudwatch_log_group_kms_key_id, null)
      },
    },
    lookup(var.service, "container_definitions", {})
  )
  cpu                                   = try(var.service.cpu, 1024)
  ephemeral_storage                     = var.service.ephemeral_storage
  family                                = var.service.family
  ipc_mode                              = var.service.ipc_mode
  memory                                = try(var.service.memory, 2048)
  network_mode                          = try(var.service.network_mode, "awsvpc")
  pid_mode                              = var.service.pid_mode
  task_definition_placement_constraints = var.service.task_definition_placement_constraints
  proxy_configuration                   = var.service.proxy_configuration
  requires_compatibilities              = try(var.service.requires_compatibilities, ["FARGATE"])
  runtime_platform = try(var.service.runtime_platform, {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  })
  skip_destroy = var.service.skip_destroy
  volume = { for k, v in merge(
    {
      efs = {
        efs_volume_configuration = {
          file_system_id     = module.efs.id
          transit_encryption = "ENABLED"
          authorization_config = {
            access_point_id = try(module.efs.access_points["atlantis"].id, null)
            iam             = "ENABLED"
          }
        }
      }
    },
    lookup(var.service, "volume", {})
  ) : k => v if var.enable_efs }
  task_tags = try(var.service.task_tags, {})

  # Task execution IAM role
  create_task_exec_iam_role               = try(var.service.create_task_exec_iam_role, true)
  task_exec_iam_role_arn                  = var.service.task_exec_iam_role_arn
  task_exec_iam_role_name                 = var.service.task_exec_iam_role_name
  task_exec_iam_role_use_name_prefix      = try(var.service.task_exec_iam_role_use_name_prefix, true)
  task_exec_iam_role_path                 = var.service.task_exec_iam_role_path
  task_exec_iam_role_description          = var.service.task_exec_iam_role_description
  task_exec_iam_role_permissions_boundary = var.service.task_exec_iam_role_permissions_boundary
  task_exec_iam_role_tags                 = try(var.service.task_exec_iam_role_tags, {})
  task_exec_iam_role_policies             = lookup(var.service, "task_exec_iam_role_policies", {})
  task_exec_iam_role_max_session_duration = var.service.task_exec_iam_role_max_session_duration

  # Task execution IAM role policy
  create_task_exec_policy  = try(var.service.create_task_exec_policy, true)
  task_exec_ssm_param_arns = try(var.service.task_exec_ssm_param_arns, [])
  task_exec_secret_arns    = try(var.service.task_exec_secret_arns, [])
  task_exec_iam_statements = lookup(var.service, "task_exec_iam_statements", [])

  # Tasks - IAM role
  create_tasks_iam_role               = try(var.service.create_tasks_iam_role, true)
  tasks_iam_role_arn                  = var.service.tasks_iam_role_arn
  tasks_iam_role_name                 = var.service.tasks_iam_role_name
  tasks_iam_role_use_name_prefix      = try(var.service.tasks_iam_role_use_name_prefix, true)
  tasks_iam_role_path                 = var.service.tasks_iam_role_path
  tasks_iam_role_description          = var.service.tasks_iam_role_description
  tasks_iam_role_permissions_boundary = var.service.tasks_iam_role_permissions_boundary
  tasks_iam_role_tags                 = try(var.service.tasks_iam_role_tags, {})
  tasks_iam_role_policies             = lookup(var.service, "tasks_iam_role_policies", {})
  tasks_iam_role_statements           = lookup(var.service, "tasks_iam_role_statements", [])

  # Task set
  external_id               = var.service.external_id
  scale                     = var.service.scale
  force_delete              = var.service.force_delete
  wait_until_stable         = try(var.service.wait_until_stable, null)
  wait_until_stable_timeout = var.service.wait_until_stable_timeout

  # Autoscaling
  enable_autoscaling            = try(var.service.enable_autoscaling, false)
  autoscaling_min_capacity      = try(var.service.autoscaling_min_capacity, 1)
  autoscaling_max_capacity      = try(var.service.autoscaling_max_capacity, 10)
  autoscaling_policies          = try(var.service.autoscaling_policies, {})
  autoscaling_scheduled_actions = try(var.service.autoscaling_scheduled_actions, {})

  # Security Group
  create_security_group          = try(var.service.create_security_group, true)
  security_group_name            = var.service.security_group_name
  security_group_use_name_prefix = try(var.service.security_group_use_name_prefix, true)
  security_group_description     = var.service.security_group_description
  security_group_ingress_rules = merge(
    {
      atlantis = {
        description                  = "Allow traffic from ALB to Atlantis"
        from_port                    = local.atlantis_port
        to_port                      = local.atlantis_port
        ip_protocol                  = "tcp"
        referenced_security_group_id = var.create_alb ? module.alb.security_group_id : var.alb_security_group_id
      }
    },
    lookup(var.service, "security_group_ingress_rules", {})
  )

  security_group_egress_rules = merge(
    {
      egress = {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
      }
    },
    lookup(var.service, "security_group_egress_rules", {})
  )

  security_group_tags = try(var.service.security_group_tags, {})

  tags = var.tags
}

################################################################################
# EFS
################################################################################

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.7.0"

  create = var.create && var.enable_efs
  name   = try(var.efs.name, var.name)

  # File system
  availability_zone_name          = try(var.efs.availability_zone_name, null)
  creation_token                  = try(var.efs.creation_token, var.name)
  performance_mode                = try(var.efs.performance_mode, null)
  encrypted                       = try(var.efs.encrypted, true)
  kms_key_arn                     = try(var.efs.kms_key_arn, null)
  provisioned_throughput_in_mibps = try(var.efs.provisioned_throughput_in_mibps, null)
  throughput_mode                 = try(var.efs.throughput_mode, null)
  lifecycle_policy                = try(var.efs.lifecycle_policy, {})

  # File system policy
  attach_policy                      = try(var.efs.attach_policy, true)
  bypass_policy_lockout_safety_check = try(var.efs.bypass_policy_lockout_safety_check, null)
  source_policy_documents            = try(var.efs.source_policy_documents, [])
  override_policy_documents          = try(var.efs.override_policy_documents, [])
  policy_statements = concat(
    [{
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
    }],
    lookup(var.efs, "policy_statements", [])
  )
  deny_nonsecure_transport = try(var.efs.deny_nonsecure_transport, true)

  # Mount targets
  mount_targets = lookup(var.efs, "mount_targets", {})

  # Security group
  create_security_group          = try(var.efs.create_security_group, true)
  security_group_name            = try(var.efs.security_group_name, "${var.name}-efs-")
  security_group_use_name_prefix = try(var.efs.security_group_use_name_prefix, true)
  security_group_description     = try(var.efs.security_group_description, null)
  security_group_vpc_id          = try(var.efs.security_group_vpc_id, var.vpc_id)
  security_group_rules = merge(
    {
      atlantis = {
        # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
        description              = "NFS ingress from Atlantis"
        source_security_group_id = module.ecs_service.security_group_id
      }
    },
    lookup(var.efs, "security_group_rules", {})
  )

  # Access point(s)
  access_points = merge(
    {
      atlantis = {
        posix_user = {
          gid = var.atlantis_gid
          uid = var.atlantis_uid
        }
        root_directory = {
          path = local.mount_path
          creation_info = {
            owner_gid   = var.atlantis_gid
            owner_uid   = var.atlantis_uid
            permissions = "0750"
          }
        }
      }
    },
    lookup(var.efs, "access_points", {})
  )

  # Backup policy
  create_backup_policy = try(var.efs.create_backup_policy, false)
  enable_backup_policy = try(var.efs.enable_backup_policy, false)

  # Replication configuration
  create_replication_configuration      = try(var.efs.create_replication_configuration, false)
  replication_configuration_destination = try(var.efs.replication_configuration_destination, {})

  tags = var.tags
}
