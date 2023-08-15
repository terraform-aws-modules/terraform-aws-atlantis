resource "github_repository_webhook" "this" {
  count = var.create ? length(var.repositories) : 0

  repository = var.repositories[count.index]

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
