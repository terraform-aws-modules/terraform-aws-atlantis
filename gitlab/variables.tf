variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  default     = "atlantis"
}

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

variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS"
  default     = ""
}

variable "acm_certificate_domain_name" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name`"
  default     = ""
}

variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record, without trailing dot"
  default     = ""
}

variable "create_route53_record" {
  description = "Whether to create Route53 record for Atlantis"
  default     = true
}

variable "ecs_service_assign_public_ip" {
  description = "Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html)"
  default     = false
}

variable "cloudwatch_log_retention_in_days" {
  description = "Retention period of Atlantis CloudWatch logs"
  default     = 7
}

variable "atlantis_image" {
  description = "Docker image to run Atlantis with. If not specified, official Atlantis image will be used"
  default     = ""
}

variable "atlantis_version" {
  description = "Verion of Atlantis to run. If not specified latest will be used"
  default     = "latest"
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = "list"
}

variable "atlantis_allowed_repo_names" {
  description = "Repositories where webhook should be created"
  type        = "list"
  default     = []
}

variable "atlantis_gitlab_user" {
  description = "gitlab username of the user that is running the Atlantis command"
}

variable "atlantis_gitlab_user_token" {
  description = "gitlab token of the user that is running the Atlantis command"
}

variable "create_gitlab_repository_webhook" {
  description = "Whether to create gitlab repository webhook for Atlantis. This requires valid gitlab credentials specified as `gitlab_token` and `gitlab_organization`."
  default     = false
}

variable "atlantis_webhook_secret" {
  description = "webhook secret"
  default     = ""
}

variable "atlantis_gitlab_base_url" {
  description = "gitlab base_url"
  default     = ""
}

variable "gitlab_organization" {
  description = "gitlab organization"
  default     = ""
}

variable "allow_repo_config" {
  description = "When true allows the use of atlantis.yaml config files within the source repos."
  type        = "string"
  default     = "false"
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = "list"
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "A map of the tags for this resource"
  type        = "map"
  default     = {
    Terraform = "true"
    Environment = "dev"
  }
}
