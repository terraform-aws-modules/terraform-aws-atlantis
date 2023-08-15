output "repository_webhook_urls" {
  description = "Webhook URL"
  value       = github_repository_webhook.this[*].url
}
