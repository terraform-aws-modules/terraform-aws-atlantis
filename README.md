# Atlantis on AWS Fargate Terraform Module

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub, GitLab and Bitbucket Cloud.

> [!CAUTION]
> Before using Atlantis and the code in this repository, please make sure that you have read and understood the security implications described in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html).

## Usage

GitHub is shown below in usage examples; however, any git provider supported by Atlantis can be used by simply using the correct Atlantis environment variables and configuring the respective webhook for the given git provider.

See the [Supplemental Docs](https://github.com/terraform-aws-modules/terraform-aws-atlantis/blob/master/docs/README.md) for additional details on integrating with git providers.

### GitHub Complete

The Atlantis module creates all resources required to run Atlantis on AWS Fargate.

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  name   = "atlantis"
  vpc_id = "vpc-1234556abcdef"

  # ECS Container Definition
  atlantis = {
    environment = [
      {
        name  = "ATLANTIS_GH_USER"
        value = "myuser"
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = "github.com/terraform-aws-modules/*"
      },
    ]
    secrets = [
      {
        name      = "ATLANTIS_GH_TOKEN"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i"
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F"
      },
    ]
  }

  # ECS Service
  service = {
    subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

    task_exec_secret_arns = [
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i",
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F",
    ]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }

  # ALB
  alb = {
    subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  }

  # ACM
  certificate_domain_name = "example.com"
  route53_zone_id         = "Z2ES7B9AZ6SHAE"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

### GitHub Separate

The Atlantis module creates most of resources required to run Atlantis on AWS Fargate, except for the ECS Cluster and ALB. This allows you to integrate Atlantis with your existing AWS infrastructure.

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  name   = "atlantis"
  vpc_id = "vpc-1234556abcdef"

  # Existing cluster
  create_cluster = false
  cluster_arn    = "arn:aws:ecs:eu-west-1:123456789012:cluster/default"

  # Existing ALB
  create_alb            = false
  alb_target_group_arn  = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
  alb_security_group_id = "sg-12345678"

  # ECS Container Definition
  atlantis = {
    environment = [
      {
        name  = "ATLANTIS_GH_USER"
        value = "myuser"
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = "github.com/terraform-aws-modules/*"
      },
    ]
    secrets = [
      {
        name      = "ATLANTIS_GH_TOKEN"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i"
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F"
      },
    ]
  }

  # ECS Service
  service = {
    subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

    task_exec_secret_arns = [
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i",
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F",
    ]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

### Utilize EFS for Persistent Storage

You can enable EFS to ensure that any plan outputs are persisted to EFS in the event that the Atlantis Task is replaced:

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  # Truncated for brevity ...

  # EFS
  enable_efs = true
  efs = {
    mount_targets = {
      "eu-west-1a" = {
        subnet_id = "subnet-xyzde987"
      }
      "eu-west-1b" = {
        subnet_id = "subnet-slkjf456"
      }
      "eu-west-1c" = {
        subnet_id = "subnet-qeiru789"
      }
    }
  }
}
```

### Supply Atlantis server configuration

`server-atlantis.yaml`

```yaml
repos:
  - id: /.*/
    allow_custom_workflows: true
    allowed_overrides:
      - apply_requirements
      - workflow
    apply_requirements:
      - approved
    workflow: default
```

`main.tf`

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  # ...

  atlantis = {
    environment = [
      {
        name : "ATLANTIS_REPO_CONFIG_JSON",
        value : jsonencode(yamldecode(file("${path.module}/server-atlantis.yaml"))),
      },
    ]
  }
}
```

## Examples

- [Complete Atlantis with GitHub webhook](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-complete)
- [Separate Atlantis with GitHub webhook](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-separate)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 6.1.1 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 10.2.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws//modules/cluster | 6.7.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | 6.7.0 |
| <a name="module_efs"></a> [efs](#module\_efs) | terraform-aws-modules/efs/aws | 2.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | Map of values passed to ALB module definition. See the [ALB module](https://github.com/terraform-aws-modules/terraform-aws-alb) for full list of arguments supported | <pre>object({<br/>    # Load Balancer<br/>    access_logs = optional(object({<br/>      bucket  = string<br/>      enabled = optional(bool, true)<br/>      prefix  = optional(string)<br/>    }))<br/>    connection_logs = optional(object({<br/>      bucket  = string<br/>      enabled = optional(bool, true)<br/>      prefix  = optional(string)<br/>    }))<br/>    drop_invalid_header_fields       = optional(bool, true)<br/>    enable_cross_zone_load_balancing = optional(bool, true)<br/>    enable_deletion_protection       = optional(bool, true)<br/>    enable_http2                     = optional(bool, true)<br/>    enable_waf_fail_open             = optional(bool)<br/>    enable_zonal_shift               = optional(bool, true)<br/>    idle_timeout                     = optional(number)<br/>    internal                         = optional(bool)<br/>    ip_address_type                  = optional(string)<br/>    name                             = optional(string)<br/>    preserve_host_header             = optional(bool)<br/>    security_groups                  = optional(list(string), [])<br/>    subnet_ids                       = optional(list(string), [])<br/><br/>    # Listener(s)<br/>    default_port              = optional(number, 80)<br/>    default_protocol          = optional(string, "HTTP")<br/>    https_listener_ssl_policy = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")<br/>    https_default_action = optional(any, {<br/>      forward = {<br/>        target_group_key = "atlantis"<br/>      }<br/>    })<br/>    https_listener = optional(any, {})<br/>    listeners      = optional(any, {})<br/><br/>    # Target Group(s)<br/>    target_groups = optional(any, {})<br/><br/>    # Securtity Group(s)<br/>    create_security_group          = optional(bool, true)<br/>    security_group_name            = optional(string)<br/>    security_group_use_name_prefix = optional(bool, true)<br/>    security_group_description     = optional(string)<br/>    security_group_ingress_rules = optional(map(object({<br/>      name                         = optional(string)<br/>      cidr_ipv4                    = optional(string)<br/>      cidr_ipv6                    = optional(string)<br/>      description                  = optional(string)<br/>      from_port                    = optional(string)<br/>      ip_protocol                  = optional(string, "tcp")<br/>      prefix_list_id               = optional(string)<br/>      referenced_security_group_id = optional(string)<br/>      tags                         = optional(map(string), {})<br/>      to_port                      = optional(string)<br/>      })),<br/>      # Default<br/>      {<br/>        http = {<br/>          from_port = 80<br/>          cidr_ipv4 = "0.0.0.0/0"<br/>        }<br/>        https = {<br/>          from_port = 443<br/>          cidr_ipv4 = "0.0.0.0/0"<br/>        }<br/>      }<br/>    )<br/>    security_group_egress_rules = optional(<br/>      map(object({<br/>        name                         = optional(string)<br/>        cidr_ipv4                    = optional(string)<br/>        cidr_ipv6                    = optional(string)<br/>        description                  = optional(string)<br/>        from_port                    = optional(string)<br/>        ip_protocol                  = optional(string, "tcp")<br/>        prefix_list_id               = optional(string)<br/>        referenced_security_group_id = optional(string)<br/>        tags                         = optional(map(string), {})<br/>        to_port                      = optional(string)<br/>      })),<br/>      # Default<br/>      {<br/>        all = {<br/>          ip_protocol = "-1"<br/>          cidr_ipv4   = "0.0.0.0/0"<br/>        }<br/>      }<br/>    )<br/>    security_group_tags = optional(map(string), {})<br/><br/>    # Route53 Record(s)<br/>    route53_records = optional(map(object({<br/>      zone_id                = string<br/>      name                   = optional(string)<br/>      type                   = string<br/>      evaluate_target_health = optional(bool, true)<br/>    })))<br/><br/>    # WAF<br/>    associate_web_acl = optional(bool, false)<br/>    web_acl_arn       = optional(string)<br/><br/>    tags = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ID of an existing security group that will be used by ALB. Required if `create_alb` is `false` | `string` | `""` | no |
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | ARN of an existing ALB target group that will be used to route traffic to the Atlantis service. Required if `create_alb` is `false` | `string` | `""` | no |
| <a name="input_atlantis"></a> [atlantis](#input\_atlantis) | Map of values passed to Atlantis container definition. See the [ECS container definition module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/container-definition) for full list of arguments supported | <pre>object({<br/>    uid = optional(string, 100)<br/>    gid = optional(string, 1000)<br/><br/>    command = optional(list(string))<br/>    cpu     = optional(number, 2048)<br/>    dependsOn = optional(list(object({<br/>      condition     = string<br/>      containerName = string<br/>    })))<br/>    disableNetworking     = optional(bool)<br/>    dnsSearchDomains      = optional(list(string))<br/>    dnsServers            = optional(list(string))<br/>    dockerLabels          = optional(map(string))<br/>    dockerSecurityOptions = optional(list(string))<br/>    entrypoint            = optional(list(string))<br/>    environment = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    environmentFiles = optional(list(object({<br/>      type  = string<br/>      value = string<br/>    })))<br/>    extraHosts = optional(list(object({<br/>      hostname  = string<br/>      ipAddress = string<br/>    })))<br/>    firelensConfiguration = optional(object({<br/>      type    = string<br/>      options = optional(map(string))<br/>      configFile = optional(object({<br/>        type    = string<br/>        content = string<br/>      }))<br/>    }))<br/>    fqdn = optional(string)<br/>    healthCheck = optional(object({<br/>      command     = optional(list(string), [])<br/>      interval    = optional(number, 30)<br/>      retries     = optional(number, 3)<br/>      startPeriod = optional(number)<br/>      timeout     = optional(number, 5)<br/>    }))<br/>    hostname = optional(string)<br/>    image    = optional(string, "ghcr.io/runatlantis/atlantis:latest")<br/>    linuxParameters = optional(object({<br/>      capabilities = optional(object({<br/>        add  = optional(list(string))<br/>        drop = optional(list(string))<br/>      }))<br/>      devices = optional(list(object({<br/>        containerPath = optional(string)<br/>        hostPath      = optional(string)<br/>        permissions   = optional(list(string))<br/>      })))<br/>      initProcessEnabled = optional(bool)<br/>      maxSwap            = optional(number)<br/>      sharedMemorySize   = optional(number)<br/>      swappiness         = optional(number)<br/>      tmpfs = optional(list(object({<br/>        containerPath = string<br/>        mountOptions  = optional(list(string))<br/>        size          = number<br/>      })))<br/>    }))<br/>    logConfiguration = optional(object({<br/>      logDriver = optional(string)<br/>      options   = optional(map(string))<br/>      secretOptions = optional(list(object({<br/>        name      = string<br/>        valueFrom = string<br/>      })))<br/>    }))<br/>    memory            = optional(number, 4096)<br/>    memoryReservation = optional(number)<br/>    mountPoints = optional(list(object({<br/>      containerPath = optional(string)<br/>      readOnly      = optional(bool)<br/>      sourceVolume  = optional(string)<br/>    })))<br/>    port                   = optional(number, 4141)<br/>    privileged             = optional(bool, false)<br/>    readonlyRootFilesystem = optional(bool, false)<br/>    repositoryCredentials = optional(object({<br/>      credentialsParameter = optional(string)<br/>    }))<br/>    resourceRequirements = optional(list(object({<br/>      type  = string<br/>      value = string<br/>    })))<br/>    restartPolicy = optional(object({<br/>      enabled              = optional(bool, true)<br/>      ignoredExitCodes     = optional(list(number))<br/>      restartAttemptPeriod = optional(number)<br/>      }),<br/>      # Default<br/>      {<br/>        enabled = true<br/>      }<br/>    )<br/>    secrets = optional(list(object({<br/>      name      = string<br/>      valueFrom = string<br/>    })))<br/>    startTimeout = optional(number, 30)<br/>    stopTimeout  = optional(number, 120)<br/>    user         = optional(string, "atlantis")<br/>    volumesFrom = optional(list(object({<br/>      readOnly        = optional(bool)<br/>      sourceContainer = optional(string)<br/>    })))<br/>    workingDirectory = optional(string)<br/><br/>    # CloudWatch Log Group<br/>    enable_cloudwatch_logging              = optional(bool, true)<br/>    create_cloudwatch_log_group            = optional(bool, true)<br/>    cloudwatch_log_group_use_name_prefix   = optional(bool, true)<br/>    cloudwatch_log_group_retention_in_days = optional(number, 14)<br/>    cloudwatch_log_group_class             = optional(string)<br/>    cloudwatch_log_group_kms_key_id        = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | `string` | `""` | no |
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | `string` | `""` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Map of values passed to ECS cluster module definition. See the [ECS cluster module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/cluster) for full list of arguments supported | <pre>object({<br/>    # Cluster<br/>    name = optional(string)<br/>    configuration = optional(object({<br/>      execute_command_configuration = optional(object({<br/>        kms_key_id = optional(string)<br/>        log_configuration = optional(object({<br/>          cloud_watch_encryption_enabled = optional(bool)<br/>          cloud_watch_log_group_name     = optional(string)<br/>          s3_bucket_encryption_enabled   = optional(bool)<br/>          s3_bucket_name                 = optional(string)<br/>          s3_kms_key_id                  = optional(string)<br/>          s3_key_prefix                  = optional(string)<br/>        }))<br/>        logging = optional(string, "OVERRIDE")<br/>      }))<br/>      managed_storage_configuration = optional(object({<br/>        fargate_ephemeral_storage_kms_key_id = optional(string)<br/>        kms_key_id                           = optional(string)<br/>      }))<br/>      }),<br/>      # Default<br/>      {<br/>        execute_command_configuration = {<br/>          log_configuration = {<br/>            cloud_watch_log_group_name = "placeholder" # will use CloudWatch log group created by module<br/>          }<br/>        }<br/>      }<br/>    )<br/>    setting = optional(list(object({<br/>      name  = string<br/>      value = string<br/>      })),<br/>      # Default<br/>      [{<br/>        name  = "containerInsights"<br/>        value = "enabled"<br/>      }]<br/>    )<br/><br/>    # Cloudwatch log group<br/>    create_cloudwatch_log_group            = optional(bool, true)<br/>    cloudwatch_log_group_retention_in_days = optional(number, 90)<br/>    cloudwatch_log_group_kms_key_id        = optional(string)<br/>    cloudwatch_log_group_class             = optional(string)<br/>    cloudwatch_log_group_tags              = optional(map(string), {})<br/><br/>    # Capacity providers<br/>    default_capacity_provider_strategy = optional(<br/>      map(object({<br/>        base   = optional(number)<br/>        name   = optional(string) # Will fall back to use map key if not set<br/>        weight = optional(number)<br/>      })),<br/>      # Default<br/>      {<br/>        FARGATE = {<br/>          weight = 100<br/>        }<br/>      }<br/>    )<br/>  })</pre> | `{}` | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of an existing ECS cluster where resources will be created. Required when `create_cluster` is `false` | `string` | `""` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Determines whether to create an ALB or not | `bool` | `true` | no |
| <a name="input_create_certificate"></a> [create\_certificate](#input\_create\_certificate) | Determines whether to create an ACM certificate or not. If `false`, `certificate_arn` must be provided | `bool` | `true` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether to create an ECS cluster or not | `bool` | `true` | no |
| <a name="input_create_route53_records"></a> [create\_route53\_records](#input\_create\_route53\_records) | Determines whether to create Route53 `A` and `AAAA` records for the loadbalancer | `bool` | `true` | no |
| <a name="input_efs"></a> [efs](#input\_efs) | Map of values passed to EFS module definition. See the [EFS module](https://github.com/terraform-aws-modules/terraform-aws-efs) for full list of arguments supported | <pre>object({<br/>    name = optional(string)<br/><br/>    # File System<br/>    availability_zone_name          = optional(string)<br/>    creation_token                  = optional(string)<br/>    performance_mode                = optional(string)<br/>    encrypted                       = optional(bool, true)<br/>    kms_key_arn                     = optional(string)<br/>    provisioned_throughput_in_mibps = optional(number)<br/>    throughput_mode                 = optional(string)<br/>    lifecycle_policy = optional(object({<br/>      transition_to_ia                    = optional(string)<br/>      transition_to_archive               = optional(string)<br/>      transition_to_primary_storage_class = optional(string)<br/>    }))<br/>    protection = optional(object({<br/>      replication_overwrite = optional(string)<br/>    }))<br/><br/>    # File System Policy<br/>    attach_policy                             = optional(bool, true)<br/>    bypass_policy_lockout_safety_check        = optional(bool)<br/>    source_policy_documents                   = optional(list(string), [])<br/>    override_policy_documents                 = optional(list(string), [])<br/>    policy_statements                         = optional(any, {})<br/>    deny_nonsecure_transport                  = optional(bool, true)<br/>    deny_nonsecure_transport_via_mount_target = optional(bool, true)<br/><br/>    # Mount targets<br/>    mount_targets = optional(map(object({<br/>      ip_address      = optional(string)<br/>      ip_address_type = optional(string)<br/>      ipv6_address    = optional(string)<br/>      region          = optional(string)<br/>      security_groups = optional(list(string), [])<br/>      subnet_id       = string<br/>      })),<br/>      # Default<br/>      {}<br/>    )<br/><br/>    # Security Group<br/>    create_security_group          = optional(bool, true)<br/>    security_group_name            = optional(string)<br/>    security_group_use_name_prefix = optional(bool, true)<br/>    security_group_description     = optional(string)<br/>    security_group_ingress_rules   = optional(any, {})<br/><br/>    # Access Point(s)<br/>    access_points = optional(any, {})<br/>  })</pre> | `{}` | no |
| <a name="input_enable_efs"></a> [enable\_efs](#input\_enable\_efs) | Determines whether to create and utilize an EFS filesystem | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Common name to use on all resources created unless a more specific name is provided | `string` | `"atlantis"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to use for ACM certificate and Route53 records | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Map of values passed to ECS service module definition. See the [ECS service module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/service) for full list of arguments supported | <pre>object({<br/>    capacity_provider_strategy = optional(map(object({<br/>      base              = optional(number)<br/>      capacity_provider = string<br/>      weight            = optional(number)<br/>    })))<br/>    deployment_circuit_breaker = optional(object({<br/>      enable   = bool<br/>      rollback = bool<br/>    }))<br/>    enable_ecs_managed_tags           = optional(bool, true)<br/>    force_new_deployment              = optional(bool, true)<br/>    health_check_grace_period_seconds = optional(number)<br/>    launch_type                       = optional(string, "FARGATE")<br/>    load_balancer                     = optional(any, {})<br/>    name                              = optional(string)<br/>    assign_public_ip                  = optional(bool, false)<br/>    security_group_ids                = optional(list(string), [])<br/>    subnet_ids                        = optional(list(string), [])<br/>    platform_version                  = optional(string)<br/>    propagate_tags                    = optional(string)<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>      update = optional(string)<br/>    }))<br/>    triggers              = optional(map(string))<br/>    wait_for_steady_state = optional(bool)<br/><br/>    # Service IAM Role<br/>    create_iam_role               = optional(bool, true)<br/>    iam_role_arn                  = optional(string)<br/>    iam_role_name                 = optional(string)<br/>    iam_role_use_name_prefix      = optional(bool, true)<br/>    iam_role_path                 = optional(string)<br/>    iam_role_description          = optional(string)<br/>    iam_role_permissions_boundary = optional(string)<br/>    iam_role_tags                 = optional(map(string), {})<br/>    iam_role_statements = optional(list(object({<br/>      sid           = optional(string)<br/>      actions       = optional(list(string))<br/>      not_actions   = optional(list(string))<br/>      effect        = optional(string)<br/>      resources     = optional(list(string))<br/>      not_resources = optional(list(string))<br/>      principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      not_principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      condition = optional(list(object({<br/>        test     = string<br/>        values   = list(string)<br/>        variable = string<br/>      })))<br/>    })))<br/><br/>    # Task Definition<br/>    create_task_definition = optional(bool, true)<br/>    task_definition_arn    = optional(string)<br/>    container_definitions  = optional(any, {})<br/>    cpu                    = optional(number, 2048)<br/>    ephemeral_storage = optional(object({<br/>      size_in_gib = number<br/>    }))<br/>    family                   = optional(string)<br/>    memory                   = optional(number, 4096)<br/>    requires_compatibilities = optional(list(string), ["FARGATE"])<br/>    runtime_platform = optional(<br/>      object({<br/>        cpu_architecture        = optional(string)<br/>        operating_system_family = optional(string)<br/>      }),<br/>      # Default<br/>      {<br/>        operating_system_family = "LINUX"<br/>        cpu_architecture        = "ARM64"<br/>      }<br/>    )<br/>    volume    = optional(any, {})<br/>    task_tags = optional(map(string), {})<br/><br/>    # Task Execution IAM Role<br/>    create_task_exec_iam_role               = optional(bool, true)<br/>    task_exec_iam_role_arn                  = optional(string)<br/>    task_exec_iam_role_name                 = optional(string)<br/>    task_exec_iam_role_use_name_prefix      = optional(bool, true)<br/>    task_exec_iam_role_path                 = optional(string)<br/>    task_exec_iam_role_description          = optional(string)<br/>    task_exec_iam_role_permissions_boundary = optional(string)<br/>    task_exec_iam_role_tags                 = optional(map(string), {})<br/>    task_exec_iam_role_policies             = optional(map(string), {})<br/>    task_exec_iam_role_max_session_duration = optional(number)<br/><br/>    # Task Execution IAM Role Policy<br/>    create_task_exec_policy  = optional(bool, true)<br/>    task_exec_ssm_param_arns = optional(list(string), [])<br/>    task_exec_secret_arns    = optional(list(string), [])<br/>    task_exec_iam_statements = optional(list(object({<br/>      sid           = optional(string)<br/>      actions       = optional(list(string))<br/>      not_actions   = optional(list(string))<br/>      effect        = optional(string)<br/>      resources     = optional(list(string))<br/>      not_resources = optional(list(string))<br/>      principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      not_principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      condition = optional(list(object({<br/>        test     = string<br/>        values   = list(string)<br/>        variable = string<br/>      })))<br/>    })))<br/><br/>    # Tasks - IAM role<br/>    create_tasks_iam_role               = optional(bool, true)<br/>    tasks_iam_role_arn                  = optional(string)<br/>    tasks_iam_role_name                 = optional(string)<br/>    tasks_iam_role_use_name_prefix      = optional(bool, true)<br/>    tasks_iam_role_path                 = optional(string)<br/>    tasks_iam_role_description          = optional(string)<br/>    tasks_iam_role_permissions_boundary = optional(string)<br/>    tasks_iam_role_tags                 = optional(map(string), {})<br/>    tasks_iam_role_policies             = optional(map(string), {})<br/>    tasks_iam_role_statements = optional(list(object({<br/>      sid           = optional(string)<br/>      actions       = optional(list(string))<br/>      not_actions   = optional(list(string))<br/>      effect        = optional(string)<br/>      resources     = optional(list(string))<br/>      not_resources = optional(list(string))<br/>      principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      not_principals = optional(list(object({<br/>        type        = string<br/>        identifiers = list(string)<br/>      })))<br/>      condition = optional(list(object({<br/>        test     = string<br/>        values   = list(string)<br/>        variable = string<br/>      })))<br/>    })))<br/><br/>    # Security Group<br/>    create_security_group          = optional(bool, true)<br/>    security_group_name            = optional(string)<br/>    security_group_use_name_prefix = optional(bool, true)<br/>    security_group_description     = optional(string)<br/>    security_group_ingress_rules   = optional(any, {})<br/>    security_group_egress_rules = optional(any,<br/>      {<br/>        egress = {<br/>          ip_protocol = "-1"<br/>          cidr_ipv4   = "0.0.0.0/0"<br/>        }<br/>      }<br/>    )<br/>    security_group_tags = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_validate_certificate"></a> [validate\_certificate](#input\_validate\_certificate) | Determines whether to validate ACM certificate using Route53 DNS. If `false`, certificate will be created but not validated | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the resources will be provisioned | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | ALB created and all of its associated outputs |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | ECS cluster created and all of its associated outputs |
| <a name="output_efs"></a> [efs](#output\_efs) | EFS created and all of its associated outputs |
| <a name="output_service"></a> [service](#output\_service) | ECS service created and all of its associated outputs |
| <a name="output_url"></a> [url](#output\_url) | URL of Atlantis |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-atlantis/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/LICENSE) for full details.

## Additional information for users from Russia and Belarus

- Russia has [illegally annexed Crimea in 2014](https://en.wikipedia.org/wiki/Annexation_of_Crimea_by_the_Russian_Federation) and [brought the war in Donbas](https://en.wikipedia.org/wiki/War_in_Donbas) followed by [full-scale invasion of Ukraine in 2022](https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine).
- Russia has brought sorrow and devastations to millions of Ukrainians, killed hundreds of innocent people, damaged thousands of buildings, and forced several million people to flee.
- [Putin khuylo!](https://en.wikipedia.org/wiki/Putin_khuylo!)
