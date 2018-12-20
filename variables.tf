variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  default     = "atlantis"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  default     = {}
}

# VPC
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  default     = ""
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = "list"
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC"
  type        = "list"
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created if `vpc_id` is not specified"
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = "list"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = "list"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = "list"
  default     = []
}

# ALB
variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = "list"
  default     = ["0.0.0.0/0"]
}

# ACM
variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS"
  default     = ""
}

variable "acm_certificate_domain_name" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name`"
  default     = ""
}

# Route53
variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record, without trailing dot"
  default     = ""
}

variable "create_route53_record" {
  description = "Whether to create Route53 record for Atlantis"
  default     = true
}

# Cloudwatch
variable "cloudwatch_log_retention_in_days" {
  description = "Retention period of Atlantis CloudWatch logs"
  default     = 7
}

# SSM parameters for secrets
variable "webhook_ssm_parameter_name" {
  description = "Name of SSM parameter to keep webhook secret"
  default     = "/atlantis/webhook/secret"
}

variable "atlantis_github_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_github_user_token"
  default     = "/atlantis/github/user/token"
}

variable "atlantis_gitlab_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_gitlab_user_token"
  default     = "/atlantis/gitlab/user/token"
}

variable "ssm_kms_key_arn" {
  type        = "string"
  description = "KMS key for SSM Parameters. Required only if your key uses a custom KMS key and not the default key."
  default     = ""
}

# ECS Service / Task
variable "ecs_service_assign_public_ip" {
  description = "Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html)"
  default     = false
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = "list"
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  default     = 200
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  default     = 50
}

variable "ecs_task_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "custom_container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used."
  default     = ""
}

# Atlantis
variable "atlantis_image" {
  description = "Docker image to run Atlantis with. If not specified, official Atlantis image will be used"
  default     = ""
}

variable "atlantis_version" {
  description = "Verion of Atlantis to run. If not specified latest will be used"
  default     = "latest"
}

variable "atlantis_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  default     = "4141"
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = "list"
}

variable "atlantis_allowed_repo_names" {
  description = "Github repositories where webhook should be created"
  type        = "list"
  default     = []
}

variable "allow_repo_config" {
  description = "When true allows the use of atlantis.yaml config files within the source repos."
  type        = "string"
  default     = "false"
}

# Github
variable "atlantis_github_user" {
  description = "GitHub username that is running the Atlantis command"
  default     = ""
}

variable "atlantis_github_user_token" {
  description = "GitHub token of the user that is running the Atlantis command"
  default     = ""
}

# Gitlab
variable "atlantis_gitlab_user" {
  description = "Gitlab username that is running the Atlantis command"
  default     = ""
}

variable "atlantis_gitlab_user_token" {
  description = "Gitlab token of the user that is running the Atlantis command"
  default     = ""
}
