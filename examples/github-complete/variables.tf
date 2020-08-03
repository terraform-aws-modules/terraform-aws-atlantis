variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance"
  type        = string
}

variable "personal_ip" {
  description = "Your current, personally ip to restrict access to Atlantis UI ending with `/32` for subnet"
  type        = string
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
