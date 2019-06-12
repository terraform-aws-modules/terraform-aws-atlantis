variable "create_gitlab_repository_webhook" {
  description = "Whether to create Gitlab repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "gitlab_base_url" {
  description = "Gitlab base_url use"
  type        = string
  default     = ""
}

variable "gitlab_token" {
  description = "Gitlab token to use when creating webhook"
  type        = string
  default     = ""
}

variable "gitlab_organization" {
  description = "Gitlab organization to use when creating webhook"
  type        = string
  default     = ""
}

variable "atlantis_allowed_repo_names" {
  description = "List of names of repositories which belong to the organization specified in `gitlab_organization`"
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
