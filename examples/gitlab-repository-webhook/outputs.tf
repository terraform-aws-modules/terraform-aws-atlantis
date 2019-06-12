output "gitlab_webhook_urls" {
  description = "Gitlab webhook URL"
  value       = module.gitlab_repository_webhook.this_repository_webhook_urls
}

output "gitlab_webhook_secret" {
  description = "Gitlab webhook secret"
  value       = module.gitlab_repository_webhook.this_repository_webhook_secret
}
