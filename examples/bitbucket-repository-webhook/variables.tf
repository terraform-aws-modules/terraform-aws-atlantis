variable "bitbucket_username" {
  description = "Bitbucket Username used to authneticate"
  type        = string
}

variable "bitbucket_password" {
  description = "Bitbucket App Password used to authenticate"
  type        = string
  default     = ""
}

variable "bitbucket_owner" {
  description = "Bitbucket owner(or org)"
  type        = string
  default     = ""
}
