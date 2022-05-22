variable "create_bitbucket_repository_webhook" {
  description = "Whether to create Bitbucket repository webhook for Atlantis"
  type        = bool
  default     = true
}

variable "bitbucket_username" {
  description = "Bitbucket Username used to authneticate"
  type        = string
  default     = null
}

variable "bitbucket_password" {
  description = "Bitbucket App Password used to authenticate"
  type        = string
  default     = null
}

variable "bitbucket_owner" {
  description = "Bitbucket owner to use when creating webhook"
  type        = string
  default     = ""
}

variable "atlantis_repo_allowlist" {
  description = "List of names of repositories"
  type        = list(string)
}

variable "webhook_url" {
  description = "Webhook URL"
  type        = string
  default     = ""
}
