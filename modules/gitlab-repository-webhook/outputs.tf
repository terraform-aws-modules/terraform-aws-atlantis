output "repository_webhook_urls" {
  description = "Webhook URL"
  value       = gitlab_project_hook.this.*.url
}

output "repository_webhook_secret" {
  description = "Webhook secret"
  value       = var.webhook_secret
  sensitive   = true
}
