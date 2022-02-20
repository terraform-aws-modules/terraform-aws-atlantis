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

variable "github_owner" {
  description = "Github owner"
  type        = string
}

variable "github_user" {
  description = "Github user for Atlantis to utilize when performing Github activities"
  type        = string
}

variable "enable_ephemeral_storage" {
  description = "By default this example uses ephemeral storage"
  type = bool
  default = true
}

variable "name" {
  description = "Name of the resource"
  type = string
  default = "github-complete"
}

variable "region" {
  description = "AWS region to deploy the resources"
  type = string
  default = "eu-west-1"
}

variable "tags" {
  description = "tags to be applied to the resources"
  type = map
  default = {
    Owner       = "user"
    Environment = "dev"
  }
}