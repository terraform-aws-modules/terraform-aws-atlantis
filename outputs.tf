output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.atlantis_url
}

output "atlantis_url_events" {
  description = "Webhook events URL of Atlantis"
  value       = module.atlantis.atlantis_url_events
}
