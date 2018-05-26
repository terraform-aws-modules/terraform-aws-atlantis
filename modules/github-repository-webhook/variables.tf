variable "create_github_repository_webhook" {
  description = "Whether to create Github repository webhook for Atlantis"
  default     = true
}

variable "github_token" {
  description = "Github token to use when creating webhook"
  default     = ""
}

variable "github_organization" {
  description = "Github organization to use when creating webhook"
  default     = ""
}

variable "github_repo_names" {
  description = "List of names of repositories which belong to the organization specified in `github_organization`"
  type        = "list"
}

variable "webhook_url" {
  description = "Webhook URL"
  default     = ""
}

variable "webhook_secret" {
  description = "Webhook secret"
  default     = ""
}
