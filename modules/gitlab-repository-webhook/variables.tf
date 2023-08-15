variable "create" {
  description = "Whether to create Gitlab repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "repositories" {
  description = "List of names of repositories which belong to the `gitlab_base_url` specified"
  type        = list(string)
  default     = []
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
