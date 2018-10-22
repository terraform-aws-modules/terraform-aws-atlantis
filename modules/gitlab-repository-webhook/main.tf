provider "gitlab" {
  token        = "${var.gitlab_token}"
  organization = "${var.gitlab_organization}"
}

resource "gitlab_repository_webhook" "this" {
  count = "${var.create_gitlab_repository_webhook && length(var.atlantis_allowed_repo_names) > 0 ? length(var.atlantis_allowed_repo_names) : 0}"

  name       = "web"
  repository = "${var.atlantis_allowed_repo_names[count.index]}"

  configuration {
    url          = "${var.webhook_url}"
    content_type = "application/json"
    insecure_ssl = false
    secret       = "${var.webhook_secret}"
  }

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
  ]

  lifecycle {
    # The secret is saved as ******* in the state
    ignore_changes = ["configuration.secret"]
  }
}
