variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Common name to use on all resources created unless a more specific name is provided"
  type        = string
  default     = "atlantis"
}

variable "atlantis" {
  description = "Map of values passed to Atlantis container definition. See the [ECS container definition module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/container-definition) for full list of arguments supported"
  type        = any
  default     = {}
}

variable "atlantis_gid" {
  description = "GID of the atlantis user"
  type        = number
  default     = 1000
}

variable "atlantis_uid" {
  description = "UID of the atlantis user"
  type        = number
  default     = 100
}

variable "vpc_id" {
  description = "ID of the VPC where the resources will be provisioned"
  type        = string
  default     = ""
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
  type        = any
  default     = {}
}

variable "alb_https_default_action" {
  description = "Default action for the ALB https listener"
  type        = any
  default = {
    forward = {
      target_group_key = "atlantis"
    }
  }
}

variable "alb_subnets" {
  description = "List of subnets to place ALB in. Required if `create_alb` is `true`"
  type        = list(string)
  default     = []
}

variable "create_route53_records" {
  description = "Determines whether to create Route53 `A` and `AAAA` records for the loadbalancer"
  type        = bool
  default     = true
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
  type        = any
  default     = {}
}

variable "service" {
  description = "Map of values passed to ECS service module definition. See the [ECS service module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/service) for full list of arguments supported"
  type        = any
  default     = {}
}

variable "service_subnets" {
  description = "List of subnets to place ECS service within"
  type        = list(string)
  default     = []
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
# EFS
################################################################################

variable "enable_efs" {
  description = "Determines whether to create and utilize an EFS filesystem"
  type        = bool
  default     = false
}

variable "efs" {
  description = "Map of values passed to EFS module definition. See the [EFS module](https://github.com/terraform-aws-modules/terraform-aws-efs) for full list of arguments supported"
  type        = any
  default     = {}
}
