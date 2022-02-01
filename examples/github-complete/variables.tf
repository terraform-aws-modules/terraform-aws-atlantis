variable "domain" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance"
  type        = string
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing"
  type        = list(string)
}

variable "github_token" {
  description = "Github token"
  type        = string
}

variable "github_owner" {
  description = "Github owner"
  type        = string
}

variable "github_user" {
  description = "Github user for Atlantis to utilize when performing Github activities"
  type        = string
}

variable "allowed_repo_names" {
  description = "Repositories that Atlantis will listen for events from and a webhook will be installed"
  type        = list(string)
}

variable "vpc_id" {
  description = "Repositories that Atlantis will listen for events from and a webhook will be installed"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "atlantis_image" {
  description = "Docker image to run Atlantis with. If not specified, official Atlantis image will be used"
  type        = string
  default     = ""
}