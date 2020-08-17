# Atlantis
output "atlantis_url" {
  description = "URL of Atlantis"
  value       = local.atlantis_url
}

output "atlantis_url_events" {
  description = "Webhook events URL of Atlantis"
  value       = local.atlantis_url_events
}

output "atlantis_allowed_repo_names" {
  description = "Git repositories where webhook should be created"
  value       = var.atlantis_allowed_repo_names
}

output "webhook_secret" {
  description = "Webhook secret"
  value       = element(concat(random_id.webhook.*.hex, [""]), 0)
}

# ECS
output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_id" {
  description = "The Atlantis ECS task role id"
  value       = aws_iam_role.ecs_task_execution.id
}

output "task_role_name" {
  description = "The Atlantis ECS task role name"
  value       = aws_iam_role.ecs_task_execution.name
}

output "task_role_unique_id" {
  description = "The stable and unique string identifying the Atlantis ECS task role."
  value       = aws_iam_role.ecs_task_execution.unique_id
}

output "ecs_task_definition" {
  description = "Task definition for ECS service (used for external triggers)"
  value       = aws_ecs_service.atlantis.task_definition
}

output "ecs_security_group" {
  description = "Security group assigned to ECS Service in network configuration"
  value       = module.atlantis_sg.this_security_group_id
}

# VPC
output "vpc_id" {
  description = "ID of the VPC that was created or passed in"
  value       = local.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the VPC private subnets that were created or passed in"
  value       = local.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs of the VPC public subnets that were created or passed in"
  value       = local.public_subnet_ids
}

# ALB
output "alb_dns_name" {
  description = "Dns name of alb"
  value       = module.alb.this_lb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of alb"
  value       = module.alb.this_lb_zone_id
}
