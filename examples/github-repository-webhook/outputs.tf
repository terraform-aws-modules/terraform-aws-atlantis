output "github_webhook_urls" {
  description = "Github webhook URL"
  value       = module.github_repository_webhook.this_repository_webhook_urls
}

output "github_webhook_secret" {
  description = "Github webhook secret"
  value       = module.github_repository_webhook.this_repository_webhook_secret
}
