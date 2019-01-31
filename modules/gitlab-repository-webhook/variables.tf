variable "create_gitlab_repository_webhook" {
  description = "Whether to create Gitlab repository webhook for Atlantis"
  default     = true
}

variable "gitlab_base_url" {
  description = "Gitlab base_url use"
  default     = ""
}

variable "gitlab_token" {
  description = "Gitlab token to use when creating webhook"
  default     = ""
}

variable "gitlab_organization" {
  description = "Gitlab organization to use when creating webhook"
  default     = ""
}

variable "atlantis_allowed_repo_names" {
  description = "List of names of repositories which belong to the organization specified in `gitlab_organization`"
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
