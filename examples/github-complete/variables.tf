variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance"
  type        = string
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing"
  type        = list(string)
}

variable "github_token" {
  description = "Github token"
  type        = string
}

variable "github_organization" {
  description = "Github organization"
  type        = string
}

variable "github_user" {
  description = "Github user for Atlantis to utilize when performing Github activities"
  type        = string
}

variable "allowed_repo_names" {
  description = "Repositories that Atlantis will listen for events from and a webhook will be installed"
  type        = list(string)
}

variable "trusted_principals" {
  description = "A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role"
  type        = list(string)
}

variable "trusted_entities" {
  description = "A list of  users or roles, that can assume the task role"
  type        = list(string)
  default     = []
}
