variable "create_github_repository_webhook" {
  description = "Whether to create Github repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "github_token" {
  description = "Github token to use when creating webhook"
  type        = string
  default     = ""
}

variable "github_organization" {
  description = "Github organization to use when creating webhook"
  type        = string
  default     = ""
}

variable "atlantis_allowed_repo_names" {
  description = "List of names of repositories which belong to the organization specified in `github_organization`"
  type        = list(string)
}

variable "webhook_url" {
  description = "Webhook URL"
  type        = string
  default     = ""
}

variable "webhook_secret" {
  description = "Webhook secret"
  type        = string
  default     = ""
}
