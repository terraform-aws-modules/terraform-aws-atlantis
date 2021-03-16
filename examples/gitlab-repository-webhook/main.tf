data "terraform_remote_state" "atlantis" {
  backend = "local"

  config = {
    path = "../../terraform.tfstate"
  }
}

module "gitlab_repository_webhook" {
  source = "../../modules/gitlab-repository-webhook"

  create_gitlab_repository_webhook = true

  gitlab_token    = var.gitlab_token
  gitlab_base_url = var.gitlab_base_url

  # Fetching these attributes from created already Atlantis Terraform state file
  atlantis_allowed_repo_names = data.terraform_remote_state.atlantis.outputs.atlantis_allowed_repo_names
  webhook_url                 = data.terraform_remote_state.atlantis.outputs.atlantis_url_events
  webhook_secret              = data.terraform_remote_state.atlantis.outputs.webhook_secret
}
