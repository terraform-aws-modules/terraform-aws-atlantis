provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository_webhook" "this" {
  count = var.create_github_repository_webhook ? length(var.atlantis_allowed_repo_names) : 0

  repository = var.atlantis_allowed_repo_names[count.index]

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
