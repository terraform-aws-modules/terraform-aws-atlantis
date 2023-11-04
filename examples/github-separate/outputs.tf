output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.url
}

################################################################################
# Load Balancer
################################################################################

output "alb" {
  description = "ALB created and all of its associated outputs"
  value       = module.atlantis.alb
}

################################################################################
# ECS
################################################################################

output "cluster" {
  description = "ECS cluster created and all of its associated outputs"
  value       = module.atlantis.cluster
}

output "service" {
  description = "ECS service created and all of its associated"
  value       = module.atlantis.service
}

################################################################################
# EFS
################################################################################

output "efs" {
  description = "EFS created and all of its associated outputs"
  value       = module.atlantis.efs
}
