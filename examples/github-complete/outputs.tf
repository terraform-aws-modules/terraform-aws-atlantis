# Atlantis
output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.atlantis_url
}

output "atlantis_allowed_repo_names" {
  description = "Git repositories where webhook should be created"
  value       = module.atlantis.atlantis_allowed_repo_names
}

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = module.atlantis.task_role_arn
}

output "ecs_task_definition" {
  description = "Task definition for ECS service (used for external triggers)"
  value       = module.atlantis.ecs_task_definition
}

# Webhooks
output "github_webhook_urls" {
  description = "Github webhook URL"
  value       = module.github_repository_webhook.this_repository_webhook_urls
}

output "github_webhook_secret" {
  description = "Github webhook secret"
  value       = module.github_repository_webhook.this_repository_webhook_secret
}
