variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  default     = "atlantis"
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = "list"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = "list"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = "list"
}

variable "certificate_arn" {
  description = "ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS"
  default     = ""
}

variable "acm_certificate_domain_name" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name`"
  default     = ""
}

variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record"
  default     = ""
}

variable "create_route53_record" {
  description = "Whether to create Route53 record for Atlantis"
  default     = true
}

//
//variable "github_token" {
//  type = "string"
//}
//
//variable "github_organization" {
//  type = "string"
//}

variable "atlantis_image" {
  description = "Docker image to run Atlantis with. If not specified, official Atlantis image will be used"
  default     = ""
}

variable "atlantis_version" {
  description = "Verion of Atlantis to run. If not specified latest will be used"
  default     = "latest"
}

variable "atlantis_github_user" {
  description = "GitHub username of the user that is running the Atlantis command"
}

variable "atlantis_github_user_token" {
  description = "GitHub token of the user that is running the Atlantis command"
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = "list"
}
