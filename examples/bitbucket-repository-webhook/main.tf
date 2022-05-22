data "terraform_remote_state" "atlantis" {
  backend = "local"

  config = {
    path = "../../terraform.tfstate"
  }
}

module "bitbucket_repository_webhook" {
  source = "../../modules/bitbucket-repository-webhook"

  create_bitbucket_repository_webhook = true

  bitbucket_username = var.bitbucket_token
  bitbucket_password = var.bitbucket_password

  # Fetching these attributes from created already Atlantis Terraform state file
  atlantis_repo_allowlist = data.terraform_remote_state.atlantis.outputs.atlantis_repo_allowlist
  webhook_url             = data.terraform_remote_state.atlantis.outputs.atlantis_url_events
}
