# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# DNS
output "atlantis_route53_record_fqdn" {
  description = "The CIDR block of the VPC"
  value       = "https://${element(concat(aws_route53_record.atlantis.*.fqdn, list("")), 0)}"
}
