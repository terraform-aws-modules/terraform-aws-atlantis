variable "create_github_repository_webhook" {
  description = "Whether to create Github repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "github_base_url" {
  description = "Github base URL to use when creating webhook (when using GitHub Enterprise)"
  type        = string
  default     = null
}

variable "github_token" {
  description = "Github token to use when creating webhook"
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "Github owner to use when creating webhook"
  type        = string
  default     = ""
}

variable "atlantis_repo_allowlist" {
  description = "List of names of repositories which belong to the owner specified in `github_owner`"
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

variable "webhook_insecure_ssl" {
  description = "Disable verify SSL certificates when delivering payloads"
  type        = bool
  default     = false
}

variable "webhook_content_type" {
  description = "Webhook Content Type"
  type        = string
  default     = "json"
  validation {
    condition     = contains(["json", "form"], var.webhook_content_type)
    error_message = "Valid values are either `json` or `form`"
  }
}
