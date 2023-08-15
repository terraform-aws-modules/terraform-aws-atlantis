resource "gitlab_project_hook" "this" {
  count = var.create ? length(var.repositories) : 0

  project                 = var.repositories[count.index]
  url                     = var.webhook_url
  token                   = var.webhook_secret
  enable_ssl_verification = false

  merge_requests_events = true
  push_events           = true
  note_events           = true
}
