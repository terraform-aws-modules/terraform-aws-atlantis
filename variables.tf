variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Common name to use on all resources created unless a more specific name is provided"
  type        = string
  default     = "atlantis"
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where the resources will be provisioned"
  type        = string
  default     = ""
}

################################################################################
# Atlantis
################################################################################

variable "atlantis" {
  description = "Map of values passed to Atlantis container definition. See the [ECS container definition module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/container-definition) for full list of arguments supported"
  type = object({
    uid = optional(string, 100)
    gid = optional(string, 1000)

    command = optional(list(string))
    cpu     = optional(number, 2048)
    dependsOn = optional(list(object({
      condition     = string
      containerName = string
    })))
    disableNetworking     = optional(bool)
    dnsSearchDomains      = optional(list(string))
    dnsServers            = optional(list(string))
    dockerLabels          = optional(map(string))
    dockerSecurityOptions = optional(list(string))
    entrypoint            = optional(list(string))
    environment = optional(list(object({
      name  = string
      value = string
    })), [])
    environmentFiles = optional(list(object({
      type  = string
      value = string
    })))
    extraHosts = optional(list(object({
      hostname  = string
      ipAddress = string
    })))
    firelensConfiguration = optional(object({
      type    = string
      options = optional(map(string))
      configFile = optional(object({
        type    = string
        content = string
      }))
    }))
    fqdn = optional(string)
    healthCheck = optional(object({
      command     = optional(list(string), [])
      interval    = optional(number, 30)
      retries     = optional(number, 3)
      startPeriod = optional(number)
      timeout     = optional(number, 5)
    }))
    hostname = optional(string)
    image    = optional(string, "ghcr.io/runatlantis/atlantis:latest")
    linuxParameters = optional(object({
      capabilities = optional(object({
        add  = optional(list(string))
        drop = optional(list(string))
      }))
      devices = optional(list(object({
        containerPath = optional(string)
        hostPath      = optional(string)
        permissions   = optional(list(string))
      })))
      initProcessEnabled = optional(bool)
      maxSwap            = optional(number)
      sharedMemorySize   = optional(number)
      swappiness         = optional(number)
      tmpfs = optional(list(object({
        containerPath = string
        mountOptions  = optional(list(string))
        size          = number
      })))
    }))
    logConfiguration = optional(object({
      logDriver = optional(string)
      options   = optional(map(string))
      secretOptions = optional(list(object({
        name      = string
        valueFrom = string
      })))
    }))
    memory            = optional(number, 4096)
    memoryReservation = optional(number)
    mountPoints = optional(list(object({
      containerPath = optional(string)
      readOnly      = optional(bool)
      sourceVolume  = optional(string)
    })))
    port                   = optional(number, 4141)
    privileged             = optional(bool, false)
    readonlyRootFilesystem = optional(bool, false)
    repositoryCredentials = optional(object({
      credentialsParameter = optional(string)
    }))
    resourceRequirements = optional(list(object({
      type  = string
      value = string
    })))
    restartPolicy = optional(object({
      enabled              = optional(bool, true)
      ignoredExitCodes     = optional(list(number))
      restartAttemptPeriod = optional(number)
      }),
      # Default
      {
        enabled = true
      }
    )
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))
    startTimeout = optional(number, 30)
    stopTimeout  = optional(number, 120)
    user         = optional(string, "atlantis")
    volumesFrom = optional(list(object({
      readOnly        = optional(bool)
      sourceContainer = optional(string)
    })))
    workingDirectory = optional(string)

    # CloudWatch Log Group
    enable_cloudwatch_logging              = optional(bool, true)
    create_cloudwatch_log_group            = optional(bool, true)
    cloudwatch_log_group_use_name_prefix   = optional(bool, true)
    cloudwatch_log_group_retention_in_days = optional(number, 14)
    cloudwatch_log_group_class             = optional(string)
    cloudwatch_log_group_kms_key_id        = optional(string)
  })
  default  = {}
  nullable = false
}

################################################################################
# Load Balancer
################################################################################

variable "create_alb" {
  description = "Determines whether to create an ALB or not"
  type        = bool
  default     = true
}

variable "alb_target_group_arn" {
  description = "ARN of an existing ALB target group that will be used to route traffic to the Atlantis service. Required if `create_alb` is `false`"
  type        = string
  default     = ""
}

variable "alb_security_group_id" {
  description = "ID of an existing security group that will be used by ALB. Required if `create_alb` is `false`"
  type        = string
  default     = ""
}

variable "alb" {
  description = "Map of values passed to ALB module definition. See the [ALB module](https://github.com/terraform-aws-modules/terraform-aws-alb) for full list of arguments supported"
  type = object({
    # Load Balancer
    access_logs = optional(object({
      bucket  = string
      enabled = optional(bool, true)
      prefix  = optional(string)
    }))
    connection_logs = optional(object({
      bucket  = string
      enabled = optional(bool, true)
      prefix  = optional(string)
    }))
    drop_invalid_header_fields       = optional(bool, true)
    enable_cross_zone_load_balancing = optional(bool, true)
    enable_deletion_protection       = optional(bool, true)
    enable_http2                     = optional(bool, true)
    enable_waf_fail_open             = optional(bool)
    enable_zonal_shift               = optional(bool, true)
    idle_timeout                     = optional(number)
    internal                         = optional(bool)
    ip_address_type                  = optional(string)
    name                             = optional(string)
    preserve_host_header             = optional(bool)
    security_groups                  = optional(list(string), [])
    subnet_ids                       = optional(list(string), [])

    # Listener(s)
    default_port              = optional(number, 80)
    default_protocol          = optional(string, "HTTP")
    https_listener_ssl_policy = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    https_default_action = optional(any, {
      forward = {
        target_group_key = "atlantis"
      }
    })
    https_listener = optional(any, {})
    listeners      = optional(any, {})

    # Target Group(s)
    target_groups = optional(any, {})

    # Securtity Group(s)
    create_security_group          = optional(bool, true)
    security_group_name            = optional(string)
    security_group_use_name_prefix = optional(bool, true)
    security_group_description     = optional(string)
    security_group_ingress_rules = optional(map(object({
      name                         = optional(string)
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      description                  = optional(string)
      from_port                    = optional(string)
      ip_protocol                  = optional(string, "tcp")
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
      tags                         = optional(map(string), {})
      to_port                      = optional(string)
      })),
      # Default
      {
        http = {
          from_port = 80
          cidr_ipv4 = "0.0.0.0/0"
        }
        https = {
          from_port = 443
          cidr_ipv4 = "0.0.0.0/0"
        }
      }
    )
    security_group_egress_rules = optional(
      map(object({
        name                         = optional(string)
        cidr_ipv4                    = optional(string)
        cidr_ipv6                    = optional(string)
        description                  = optional(string)
        from_port                    = optional(string)
        ip_protocol                  = optional(string, "tcp")
        prefix_list_id               = optional(string)
        referenced_security_group_id = optional(string)
        tags                         = optional(map(string), {})
        to_port                      = optional(string)
      })),
      # Default
      {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    )
    security_group_tags = optional(map(string), {})

    # Route53 Record(s)
    route53_records = optional(map(object({
      zone_id                = string
      name                   = optional(string)
      type                   = string
      evaluate_target_health = optional(bool, true)
    })))

    # WAF
    associate_web_acl = optional(bool, false)
    web_acl_arn       = optional(string)

    tags = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "create_route53_records" {
  description = "Determines whether to create Route53 `A` and `AAAA` records for the loadbalancer"
  type        = bool
  default     = true
}

################################################################################
# ACM
################################################################################

variable "create_certificate" {
  description = "Determines whether to create an ACM certificate or not. If `false`, `certificate_arn` must be provided"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS"
  type        = string
  default     = ""
}

variable "certificate_domain_name" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name`"
  type        = string
  default     = ""
}

variable "validate_certificate" {
  description = "Determines whether to validate ACM certificate using Route53 DNS. If `false`, certificate will be created but not validated"
  type        = bool
  default     = true
}

variable "route53_zone_id" {
  description = "Route53 zone ID to use for ACM certificate and Route53 records"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB."
  type        = string
  default     = null
}

################################################################################
# ECS
################################################################################

variable "create_cluster" {
  description = "Whether to create an ECS cluster or not"
  type        = bool
  default     = true
}

variable "cluster_arn" {
  description = "ARN of an existing ECS cluster where resources will be created. Required when `create_cluster` is `false`"
  type        = string
  default     = ""
}

variable "cluster" {
  description = "Map of values passed to ECS cluster module definition. See the [ECS cluster module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/cluster) for full list of arguments supported"
  type = object({
    # Cluster
    name = optional(string)
    configuration = optional(object({
      execute_command_configuration = optional(object({
        kms_key_id = optional(string)
        log_configuration = optional(object({
          cloud_watch_encryption_enabled = optional(bool)
          cloud_watch_log_group_name     = optional(string)
          s3_bucket_encryption_enabled   = optional(bool)
          s3_bucket_name                 = optional(string)
          s3_kms_key_id                  = optional(string)
          s3_key_prefix                  = optional(string)
        }))
        logging = optional(string, "OVERRIDE")
      }))
      managed_storage_configuration = optional(object({
        fargate_ephemeral_storage_kms_key_id = optional(string)
        kms_key_id                           = optional(string)
      }))
      }),
      # Default
      {
        execute_command_configuration = {
          log_configuration = {
            cloud_watch_log_group_name = "placeholder" # will use CloudWatch log group created by module
          }
        }
      }
    )
    setting = optional(list(object({
      name  = string
      value = string
      })),
      # Default
      [{
        name  = "containerInsights"
        value = "enabled"
      }]
    )

    # Cloudwatch log group
    create_cloudwatch_log_group            = optional(bool, true)
    cloudwatch_log_group_retention_in_days = optional(number, 90)
    cloudwatch_log_group_kms_key_id        = optional(string)
    cloudwatch_log_group_class             = optional(string)
    cloudwatch_log_group_tags              = optional(map(string), {})

    # Capacity providers
    default_capacity_provider_strategy = optional(
      map(object({
        base   = optional(number)
        name   = optional(string) # Will fall back to use map key if not set
        weight = optional(number)
      })),
      # Default
      {
        FARGATE = {
          weight = 100
        }
      }
    )
  })
  default = {}
}

variable "service" {
  description = "Map of values passed to ECS service module definition. See the [ECS service module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/service) for full list of arguments supported"
  type = object({
    capacity_provider_strategy = optional(map(object({
      base              = optional(number)
      capacity_provider = string
      weight            = optional(number)
    })))
    deployment_circuit_breaker = optional(object({
      enable   = bool
      rollback = bool
    }))
    enable_ecs_managed_tags           = optional(bool, true)
    force_new_deployment              = optional(bool, true)
    health_check_grace_period_seconds = optional(number)
    launch_type                       = optional(string, "FARGATE")
    load_balancer                     = optional(any, {})
    name                              = optional(string)
    assign_public_ip                  = optional(bool, false)
    security_group_ids                = optional(list(string), [])
    subnet_ids                        = optional(list(string), [])
    platform_version                  = optional(string)
    propagate_tags                    = optional(string)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
    triggers              = optional(map(string))
    wait_for_steady_state = optional(bool)

    # Service IAM Role
    create_iam_role               = optional(bool, true)
    iam_role_arn                  = optional(string)
    iam_role_name                 = optional(string)
    iam_role_use_name_prefix      = optional(bool, true)
    iam_role_path                 = optional(string)
    iam_role_description          = optional(string)
    iam_role_permissions_boundary = optional(string)
    iam_role_tags                 = optional(map(string), {})
    iam_role_statements = optional(list(object({
      sid           = optional(string)
      actions       = optional(list(string))
      not_actions   = optional(list(string))
      effect        = optional(string)
      resources     = optional(list(string))
      not_resources = optional(list(string))
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      not_principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      condition = optional(list(object({
        test     = string
        values   = list(string)
        variable = string
      })))
    })))

    # Task Definition
    create_task_definition = optional(bool, true)
    task_definition_arn    = optional(string)
    container_definitions  = optional(any, {})
    cpu                    = optional(number, 2048)
    ephemeral_storage = optional(object({
      size_in_gib = number
    }))
    family                   = optional(string)
    memory                   = optional(number, 4096)
    requires_compatibilities = optional(list(string), ["FARGATE"])
    runtime_platform = optional(
      object({
        cpu_architecture        = optional(string)
        operating_system_family = optional(string)
      }),
      # Default
      {
        operating_system_family = "LINUX"
        cpu_architecture        = "ARM64"
      }
    )
    volume    = optional(any, {})
    task_tags = optional(map(string), {})

    # Task Execution IAM Role
    create_task_exec_iam_role               = optional(bool, true)
    task_exec_iam_role_arn                  = optional(string)
    task_exec_iam_role_name                 = optional(string)
    task_exec_iam_role_use_name_prefix      = optional(bool, true)
    task_exec_iam_role_path                 = optional(string)
    task_exec_iam_role_description          = optional(string)
    task_exec_iam_role_permissions_boundary = optional(string)
    task_exec_iam_role_tags                 = optional(map(string), {})
    task_exec_iam_role_policies             = optional(map(string), {})
    task_exec_iam_role_max_session_duration = optional(number)

    # Task Execution IAM Role Policy
    create_task_exec_policy  = optional(bool, true)
    task_exec_ssm_param_arns = optional(list(string), [])
    task_exec_secret_arns    = optional(list(string), [])
    task_exec_iam_statements = optional(list(object({
      sid           = optional(string)
      actions       = optional(list(string))
      not_actions   = optional(list(string))
      effect        = optional(string)
      resources     = optional(list(string))
      not_resources = optional(list(string))
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      not_principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      condition = optional(list(object({
        test     = string
        values   = list(string)
        variable = string
      })))
    })))

    # Tasks - IAM role
    create_tasks_iam_role               = optional(bool, true)
    tasks_iam_role_arn                  = optional(string)
    tasks_iam_role_name                 = optional(string)
    tasks_iam_role_use_name_prefix      = optional(bool, true)
    tasks_iam_role_path                 = optional(string)
    tasks_iam_role_description          = optional(string)
    tasks_iam_role_permissions_boundary = optional(string)
    tasks_iam_role_tags                 = optional(map(string), {})
    tasks_iam_role_policies             = optional(map(string), {})
    tasks_iam_role_statements = optional(list(object({
      sid           = optional(string)
      actions       = optional(list(string))
      not_actions   = optional(list(string))
      effect        = optional(string)
      resources     = optional(list(string))
      not_resources = optional(list(string))
      principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      not_principals = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      condition = optional(list(object({
        test     = string
        values   = list(string)
        variable = string
      })))
    })))

    # Security Group
    create_security_group          = optional(bool, true)
    security_group_name            = optional(string)
    security_group_use_name_prefix = optional(bool, true)
    security_group_description     = optional(string)
    security_group_ingress_rules   = optional(any, {})
    security_group_egress_rules = optional(any,
      {
        egress = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    )
    security_group_tags = optional(map(string), {})
  })
  default = {}
}

################################################################################
# EFS
################################################################################

variable "enable_efs" {
  description = "Determines whether to create and utilize an EFS filesystem"
  type        = bool
  default     = false
}

variable "efs" {
  description = "Map of values passed to EFS module definition. See the [EFS module](https://github.com/terraform-aws-modules/terraform-aws-efs) for full list of arguments supported"
  type = object({
    name = optional(string)

    # File System
    availability_zone_name          = optional(string)
    creation_token                  = optional(string)
    performance_mode                = optional(string)
    encrypted                       = optional(bool, true)
    kms_key_arn                     = optional(string)
    provisioned_throughput_in_mibps = optional(number)
    throughput_mode                 = optional(string)
    lifecycle_policy = optional(object({
      transition_to_ia                    = optional(string)
      transition_to_archive               = optional(string)
      transition_to_primary_storage_class = optional(string)
    }))
    protection = optional(object({
      replication_overwrite = optional(string)
    }))

    # File System Policy
    attach_policy                             = optional(bool, true)
    bypass_policy_lockout_safety_check        = optional(bool)
    source_policy_documents                   = optional(list(string), [])
    override_policy_documents                 = optional(list(string), [])
    policy_statements                         = optional(any, {})
    deny_nonsecure_transport                  = optional(bool, true)
    deny_nonsecure_transport_via_mount_target = optional(bool, true)

    # Mount targets
    mount_targets = optional(map(object({
      ip_address      = optional(string)
      ip_address_type = optional(string)
      ipv6_address    = optional(string)
      region          = optional(string)
      security_groups = optional(list(string), [])
      subnet_id       = string
      })),
      # Default
      {}
    )

    # Security Group
    create_security_group          = optional(bool, true)
    security_group_name            = optional(string)
    security_group_use_name_prefix = optional(bool, true)
    security_group_description     = optional(string)
    security_group_ingress_rules   = optional(any, {})

    # Access Point(s)
    access_points = optional(any, {})
  })
  default = {}
}
