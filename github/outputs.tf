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

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = "${aws_iam_role.ecs_task_execution.arn}"
}
