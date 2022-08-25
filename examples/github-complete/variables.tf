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

variable "github_repo_names" {
  description = "List of Github repositories that should be monitored by Atlantis"
  type        = list(string)
}

variable "github_app_id" {
  type        = string
  description = "GitHub App ID that is running the Atlantis command"
}

variable "github_app_key" {
  description = "The PEM encoded private key for the GitHub App"
  type        = string
}

variable "github_webhook_secret" {
  description = "Webhook secret"
  type        = string
}
