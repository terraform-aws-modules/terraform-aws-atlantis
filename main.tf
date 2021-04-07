module "atlantis" {
  source = "./modules/atlantis"

  atlantis_image = "008963853103.dkr.ecr.us-east-1.amazonaws.com/atlantis:latest"

  policies_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  # GitHub
  atlantis_github_webhook_secret_ssm_parameter_name = "/atlantis/webhook/secret"
  atlantis_github_organization                      = "tophatmonocle"
  atlantis_github_app_id                            = "85044"
  atlantis_repo_whitelist                           = ["github.com/tophatmonocle/boilerplate-service", "github.com/tophatmonocle/student-item-policy-service"]
  atlantis_repo_config_json                         = "server-side-repo-config/repos.json"
  atlantis_github_app_key_file                      = "/home/atlantis/atlantis-app-key.pem"

  # VPC
  vpc_id                  = "vpc-d92765bf"
  private_subnet_ids      = ["subnet-f8f3d1a3", "subnet-e999fcd5"]
  public_subnet_ids       = ["subnet-f9f3d1a2", "subnet-e899fcd4"]
  alb_ingress_cidr_blocks = []

  # DNS
  route53_zone_name = "dev.tophat.com"
}
