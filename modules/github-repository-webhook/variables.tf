variable "create" {
  description = "Whether to create Github repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "repositories" {
  description = "List of names of repositories which belong to the owner specified in `github_owner`"
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
