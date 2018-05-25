output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "atlantis_route53_record_fqdn" {
  description = "The CIDR block of the VPC"
  value       = "https://${element(concat(aws_route53_record.atlantis.*.fqdn, list("")), 0)}"
}

output "github_webhook_secret" {
  description = "Github webhook secret"
  value       = "${random_id.webhook.hex}"
}
