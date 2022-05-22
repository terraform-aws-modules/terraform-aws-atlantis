provider "bitbucket" {
  username = var.bitbucket_username
  password = var.bitbucket_password
}

resource "bitbucket_hook" "this" {
  count = var.create_bitbucket_repository_webhook ? length(var.atlantis_repo_allowlist) : 0

  owner       = var.bitbucket_owner
  repository  = var.atlantis_repo_allowlist[count.index]
  url         = var.webhook_url
  description = "Atlantis Webhook for ${var.atlantis_repo_allowlist[count.index]}"

  events = [
    "pullrequest:created",
    "pullrequest:rejected",
    "pullrequest:fulfilled",
    "pullrequest:updated",
    "pullrequest:comment_created",
  ]
}
