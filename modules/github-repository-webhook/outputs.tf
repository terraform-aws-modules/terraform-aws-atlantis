output "this_repository_webhook_urls" {
  description = "Webhook URL"
  value       = github_repository_webhook.this.*.url
}

output "this_repository_webhook_secret" {
  description = "Webhook secret"
  value       = var.webhook_secret
}
