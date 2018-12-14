output "atlantis_url" {
  description = "URL of Atlantis"
  value       = "${local.atlantis_url}"
}

output "atlantis_url_events" {
  description = "Webhook events URL of Atlantis"
  value       = "${local.atlantis_url_events}"
}

output "atlantis_allowed_repo_names" {
  description = "Github repositories where webhook should be created"
  value       = "${var.atlantis_allowed_repo_names}"
}

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = "${aws_iam_role.ecs_task_execution.arn}"
}

output "webhook_secret" {
  value = "${random_id.webhook.hex}"
}
