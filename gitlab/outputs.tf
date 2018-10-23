output "atlantis_url" {
  description = "URL of Atlantis"
  value       = "${local.atlantis_url}"
}

output "gitlab_webhook_secret" {
  description = "gitlab webhook secret"
  value       = "${module.gitlab_repository_webhook.this_repository_webhook_secret}"
}

output "gitlab_webhook_urls" {
  description = "gitlab webhook URL"
  value       = "${module.gitlab_repository_webhook.this_repository_webhook_urls}"
}

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = "${aws_iam_role.ecs_task_execution.arn}"
}
