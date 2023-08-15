output "url" {
  description = "URL of Atlantis"
  value       = local.atlantis_url
}

################################################################################
# Load Balancer
################################################################################

output "alb" {
  description = "ALB created and all of its associated outputs"
  value       = module.alb
}

################################################################################
# ECS
################################################################################

output "cluster" {
  description = "ECS cluster created and all of its associated outputs"
  value       = module.ecs_cluster
}

output "service" {
  description = "ECS service created and all of its associated outputs"
  value       = module.ecs_service
}

################################################################################
# EFS
################################################################################

output "efs" {
  description = "EFS created and all of its associated outputs"
  value       = module.efs
}
