module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "~> 2.0"

  name = "atlantis"

  # VPC
  vpc_id             = "vpc-0cf725492282694a0"
  private_subnet_ids = ["subnet-0fad5dd57605b4e6d"]
  public_subnet_ids  = [subnet-0ec057962d49f0daa]

  # DNS (without trailing dot)
  # route53_zone_name = "example.com"

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  # certificate_arn = "arn:aws:acm:eu-west-1:135367859851:certificate/70e008e1-c0e1-4c7e-9670-7bb5bd4f5a84"

  # Atlantis
  atlantis_github_user       = "atlantisbot-smnzrn"
  atlantis_github_user_token = "a689f9133fe5401b8121e3a522b7db25e89e3f74"
  atlantis_repo_whitelist    = ["github.com/terraform-aws-modules/*"]
}
