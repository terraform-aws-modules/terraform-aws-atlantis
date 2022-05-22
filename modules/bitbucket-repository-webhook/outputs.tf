output "repository_webhook_urls" {
  description = "Webhook URL"
  value       = bitbucket_hook.this.*.url
}
