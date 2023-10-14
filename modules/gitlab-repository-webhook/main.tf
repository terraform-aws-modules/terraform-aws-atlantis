provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_base_url
}

resource "gitlab_project_hook" "this" {
  count = var.create_gitlab_repository_webhook ? length(local.tfsettings.atlantis_repo_allowlist) : 0

  project                 = local.tfsettings.atlantis_repo_allowlist[count.index]
  url                     = var.webhook_url
  token                   = var.webhook_secret
  enable_ssl_verification = false

  merge_requests_events = true
  push_events           = true
  note_events           = true
}
