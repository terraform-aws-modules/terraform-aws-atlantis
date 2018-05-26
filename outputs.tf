output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "atlantis_url" {
  description = "URL of Atlantis"
  value       = "${local.atlantis_url}"
}

output "github_webhook_secret" {
  description = "Github webhook secret"
  value       = "${module.github_repository_webhook.this_repository_webhook_secret}"
}

output "github_webhook_urls" {
  description = "Github webhook URL"
  value       = "${module.github_repository_webhook.this_repository_webhook_urls}"
}
