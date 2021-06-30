variable "domain_name" {
  type        = string
  description = "Atlantis domain name"
  default     = "2w.laiello.com"
}

variable "github_user_token" {
  description = "Github personal token"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "Github personal token"
  type        = string
  sensitive   = true
}

variable "s3_state_buckets" {
  description = "List of S3 buckets where Terraform state is stored (can be in any account)."
  type        = list(string)
  default     = ["secndwatch-remote-state-development", "laiello-terraform-tfstate"]
}

variable "atlantis_repo_allowlist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = list(string)
  default     = ["github.com/2ndWatch/*", "github.com/aiell0/*"]
}
