output "repository_webhook_urls" {
  description = "Webhook URL"
  value       = gitlab_project_hook.this[*].url
}
