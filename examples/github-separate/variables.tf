variable "github_token" {
  description = "Github token to use when creating webhook"
  type        = string
}

variable "github_owner" {
  description = "Github owner to use when creating webhook"
  type        = string
}

variable "atlantis_github_user" {
  description = "GitHub user or organization name"
  type        = string
}

variable "atlantis_repo_allowlist" {
  description = "List of GitHub repositories that Atlantis will be allowed to access"
  type        = list(string)
}

variable "repositories" {
  description = "List of GitHub repositories to create webhooks for. This is just the name of the repository, excluding the user or organization"
  type        = list(string)
}
