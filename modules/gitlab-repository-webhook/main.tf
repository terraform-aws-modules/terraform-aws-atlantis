provider "gitlab" {
  token        = "${var.gitlab_token}"
}

resource "gitlab_project" "sample_project" {
    name = "${var.gitlab_organization}"
}

resource "gitlab_project_hook" "this" {
  count = "${var.create_gitlab_repository_webhook && length(var.atlantis_allowed_repo_names) > 0 ? length(var.atlantis_allowed_repo_names) : 0}"

  name       = "web"
  repository = "${var.atlantis_allowed_repo_names[count.index]}"

  configuration {
    url          = "${var.webhook_url}"
    #content_type = "application/json"
    enable_ssl_verification = "false"
    token       = "${var.webhook_secret}"
  }

  merge_requests_events = "true"
  push_events = "true"
  note_events = "true"

  lifecycle {
    # The secret is saved as ******* in the state
    ignore_changes = ["configuration.secret"]
  }
}
