data "terraform_remote_state" "atlantis" {
  backend = "local"

  config = {
    path = "../../terraform.tfstate"
  }
}

module "github_repository_webhook" {
  source = "../../modules/github-repository-webhook"

  create_github_repository_webhook = true

  github_token        = var.github_token
  github_organization = var.github_organization

  # Fetching these attributes from created already Atlantis Terraform state file
  #
  # This assumes that you are the owner of these repositories and they are available at:
  # https://github.com/mygithubusername/awesome-repo and https://github.com/mygithubusername/another-awesome-repo
  atlantis_allowed_repo_names = data.terraform_remote_state.atlantis.outputs.atlantis_allowed_repo_names

  webhook_url    = data.terraform_remote_state.atlantis.outputs.atlantis_url_events
  webhook_secret = data.terraform_remote_state.atlantis.outputs.webhook_secret
}
