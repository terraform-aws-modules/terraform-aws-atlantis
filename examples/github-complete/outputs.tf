# Atlantis
output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.atlantis_url
}

output "atlantis_github_app_setup_url" {
  description = "URL to create a new Github App with Atlantis"
  value       = "${module.atlantis.atlantis_url}/github-app/setup"
}

output "atlantis_repo_allowlist" {
  description = "Git repositories where webhook should be created"
  value       = module.atlantis.atlantis_repo_allowlist
}

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = module.atlantis.task_role_arn
}

output "ecs_task_definition" {
  description = "Task definition for ECS service (used for external triggers)"
  value       = module.atlantis.ecs_task_definition
}
