provider "github" {
  base_url = var.github_base_url
  token    = var.github_token
  owner    = var.github_owner
}

resource "github_repository_webhook" "this" {
  count = var.create_github_repository_webhook ? length(var.atlantis_repo_allowlist) : 0

  repository = var.atlantis_repo_allowlist[count.index]

  configuration {
    url          = var.webhook_url
    content_type = "application/json"
    insecure_ssl = false
    secret       = var.webhook_secret
  }

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
  ]
}
