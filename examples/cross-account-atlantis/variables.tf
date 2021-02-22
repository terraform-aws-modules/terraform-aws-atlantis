variable "domain_name" {
  type        = string
  description = "Atlantis domain name"
  default     = "2w.laiello.com"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate for Atlantis"
  default     = "arn:aws:acm:us-east-1:966064235577:certificate/a7fc1081-6709-4469-b605-e5147fabba46"
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
  default     = ["terraform-state-laiello2wsandbox"]
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = list(string)
  default     = ["github.com/2ndWatch/cco-tf-demo"]
}
