variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type        = string
  default     = "atlantis"
}

variable "internal" {
  description = "Whether the load balancer is internal or external"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "alb_https_security_group_tags" {
  description = "Additional tags to put on the https security group"
  type        = map(string)
  default     = {}
}

variable "alb_http_security_group_tags" {
  description = "Additional tags to put on the http security group"
  type        = map(string)
  default     = {}
}

variable "atlantis_security_group_tags" {
  description = "Additional tags to put on the atlantis security group"
  type        = map(string)
  default     = {}
}

variable "atlantis_fqdn" {
  description = "FQDN of Atlantis to use. Set this only to override Route53 and ALB's DNS name."
  type        = string
  default     = null
}

# VPC
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created if `vpc_id` is not specified"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

# ALB
variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_log_bucket_name" {
  description = "S3 bucket (externally created) for storing load balancer access logs. Required if alb_logging_enabled is true."
  type        = string
  default     = ""
}

variable "alb_log_location_prefix" {
  description = "S3 prefix within the log_bucket_name under which logs are stored."
  type        = string
  default     = ""
}

variable "alb_logging_enabled" {
  description = "Controls if the ALB will log requests to S3."
  type        = bool
  default     = false
}

variable "alb_authenticate_oidc" {
  description = "Map of Authenticate OIDC parameters to protect ALB (eg, using Auth0). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-oidc-action"
  type        = any
  default     = {}
}

variable "alb_authenticate_cognito" {
  description = "Map of AWS Cognito authentication parameters to protect ALB (eg, using SAML). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-cognito-action"
  type        = any
  default     = {}
}

variable "allow_unauthenticated_access" {
  description = "Whether to create ALB listener rule to allow unauthenticated access for certain CIDR blocks (eg. allow GitHub webhooks to bypass OIDC authentication)"
  type        = bool
  default     = false
}

variable "allow_unauthenticated_access_path_pattern" {
  description = "The pattern to allow unauthenticated access (eg. allow GitHub webhooks for /events)"
  type        = string
  default     = "*"
}

variable "allow_unauthenticated_access_priority" {
  description = "ALB listener rule priority for allow unauthenticated access rule"
  type        = number
  default     = 10
}

variable "allow_github_webhooks" {
  description = "Whether to allow access for GitHub webhooks"
  type        = bool
  default     = false
}

variable "github_webhooks_cidr_blocks" {
  description = "List of CIDR blocks used by GitHub webhooks" # This is hardcoded to avoid dependency on github provider. Source: https://api.github.com/meta
  type        = list(string)
  default     = ["140.82.112.0/20", "185.199.108.0/22", "192.30.252.0/22"]
}

variable "whitelist_unauthenticated_cidr_blocks" {
  description = "List of allowed CIDR blocks to bypass authentication"
  type        = list(string)
  default     = []
}

variable "alb_listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

# ACM
variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS"
  type        = string
  default     = ""
}

variable "acm_certificate_domain_name" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name`"
  type        = string
  default     = ""
}

# Route53
variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record, without trailing dot"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB."
  type        = string
  default     = null
}

variable "create_route53_record" {
  description = "Whether to create Route53 record for Atlantis"
  type        = bool
  default     = true
}

# Cloudwatch
variable "cloudwatch_log_retention_in_days" {
  description = "Retention period of Atlantis CloudWatch logs"
  type        = number
  default     = 7
}

# SSM parameters for secrets
variable "webhook_ssm_parameter_name" {
  description = "Name of SSM parameter to keep webhook secret"
  type        = string
  default     = "/atlantis/webhook/secret"
}

variable "atlantis_github_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_github_user_token"
  type        = string
  default     = "/atlantis/github/user/token"
}

variable "atlantis_gitlab_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_gitlab_user_token"
  type        = string
  default     = "/atlantis/gitlab/user/token"
}

variable "atlantis_bitbucket_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_bitbucket_user_token"
  type        = string
  default     = "/atlantis/bitbucket/user/token"
}

variable "ssm_kms_key_arn" {
  description = "ARN of KMS key to use for encryption and decryption of SSM Parameters. Required only if your key uses a custom KMS key and not the default key"
  type        = string
  default     = ""
}

# ECS Service / Task
variable "ecs_service_assign_public_ip" {
  description = "Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html)"
  type        = bool
  default     = false
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

variable "trusted_principals" {
  description = "A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role"
  type        = list(string)
  default     = []
}

variable "ecs_fargate_spot" {
  description = "Whether to run ECS Fargate Spot or not"
  type        = bool
  default     = false
}

variable "ecs_container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = false
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "ecs_service_platform_version" {
  description = "The platform version on which to run your service"
  type        = string
  default     = "LATEST"
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 50
}

variable "ecs_task_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}

variable "container_memory_reservation" {
  description = "The amount of memory (in MiB) to reserve for the container"
  type        = number
  default     = 128
}

variable "custom_container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used."
  type        = string
  default     = ""
}

variable "extra_container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. These will be provided as supplimentary to the main Atlantis container definition"
  type        = list(any)
  default     = []
}

variable "entrypoint" {
  description = "The entry point that is passed to the container"
  type        = list(string)
  default     = null
}

variable "command" {
  description = "The command that is passed to the container"
  type        = list(string)
  default     = null
}

variable "working_directory" {
  description = "The working directory to run commands inside the container"
  type        = string
  default     = null
}

variable "repository_credentials" {
  description = "Container repository credentials; required when using a private repo.  This map currently supports a single key; \"credentialsParameter\", which should be the ARN of a Secrets Manager's secret holding the credentials"
  type        = map(string)
  default     = null
}

variable "docker_labels" {
  description = "The configuration options to send to the `docker_labels`"
  type        = map(string)
  default     = null
}

variable "start_timeout" {
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container"
  type        = number
  default     = 30
}

variable "stop_timeout" {
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own"
  type        = number
  default     = 30
}

variable "container_depends_on" {
  description = "The dependencies defined for container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The condition can be one of START, COMPLETE, SUCCESS or HEALTHY"
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = null
}

variable "essential" {
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
  type        = bool
  default     = true
}

variable "readonly_root_filesystem" {
  description = "Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value"
  type        = bool
  default     = false
}

variable "mount_points" {
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  type        = list
  default     = []
}

variable "volumes_from" {
  description = "A list of VolumesFrom maps which contain \"sourceContainer\" (name of the container that has the volumes to mount) and \"readOnly\" (whether the container can write to the volume)"
  type = list(object({
    sourceContainer = string
    readOnly        = bool
  }))
  default = []
}

variable "user" {
  description = "The user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group. The default (null) will use the container's configured `USER` directive or root if not set."
  type        = string
  default     = null
}

variable "ulimits" {
  description = "Container ulimit settings. This is a list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  type = list(object({
    name      = string
    hardLimit = number
    softLimit = number
  }))
  default = null
}

# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html
variable "firelens_configuration" {
  description = "The FireLens configuration for the container. This is used to specify and configure a log router for container logs. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html"
  type = object({
    type    = string
    options = map(string)
  })
  default = null
}

# Atlantis
variable "atlantis_image" {
  description = "Docker image to run Atlantis with. If not specified, official Atlantis image will be used"
  type        = string
  default     = ""
}

variable "atlantis_version" {
  description = "Verion of Atlantis to run. If not specified latest will be used"
  type        = string
  default     = "latest"
}

variable "atlantis_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  type        = number
  default     = 4141
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = list(string)
}

variable "atlantis_allowed_repo_names" {
  description = "Git repositories where webhook should be created"
  type        = list(string)
  default     = []
}

variable "allow_repo_config" {
  description = "When true allows the use of atlantis.yaml config files within the source repos."
  type        = string
  default     = "false"
}

variable "atlantis_log_level" {
  description = "Log level that Atlantis will run with. Accepted values are: <debug|info|warn|error>"
  type        = string
  default     = "debug"
}

variable "atlantis_hide_prev_plan_comments" {
  description = "Enables atlantis server --hide-prev-plan-comments hiding previous plan comments on update"
  type        = string
  default     = "false"
}

# Github
variable "atlantis_github_user" {
  description = "GitHub username that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_github_user_token" {
  description = "GitHub token of the user that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_github_webhook_secret" {
  description = "GitHub webhook secret of an app that is running the Atlantis command"
  type        = string
  default     = ""
}

# Gitlab
variable "atlantis_gitlab_user" {
  description = "Gitlab username that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_gitlab_user_token" {
  description = "Gitlab token of the user that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_gitlab_hostname" {
  description = "Gitlab server hostname, defaults to gitlab.com"
  type        = string
  default     = "gitlab.com"
}

# Bitbucket
variable "atlantis_bitbucket_user" {
  description = "Bitbucket username that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_bitbucket_user_token" {
  description = "Bitbucket token of the user that is running the Atlantis command"
  type        = string
  default     = ""
}

variable "atlantis_bitbucket_base_url" {
  description = "Base URL of Bitbucket Server, use for Bitbucket on prem (Stash)"
  type        = string
  default     = ""
}

variable "custom_environment_secrets" {
  description = "List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`)"
  type = list(object(
    {
      name      = string
      valueFrom = string
    }
  ))
  default = []
}

variable "custom_environment_variables" {
  description = "List of additional environment variables the container will use (list should contain maps with `name` and `value`)"
  type = list(object(
    {
      name  = string
      value = string
    }
  ))
  default = []
}

variable "security_group_ids" {
  description = "List of one or more security groups to be added to the load balancer"
  type        = list(string)
  default     = []
}
