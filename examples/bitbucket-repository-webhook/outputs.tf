output "bitbucket_webhook_urls" {
  description = "Gitlab webhook URL"
  value       = module.bitbucket_repository_webhook.repository_webhook_urls
}
