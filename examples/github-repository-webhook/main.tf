data "terraform_remote_state" "atlantis" {
  backend = "local"

  config = {
    path = "../github-complete/terraform.tfstate"
  }
}

module "github_repository_webhook" {
  source = "../../modules/github-repository-webhook"

  create_github_repository_webhook = true


  github_owner = var.github_owner

  # Fetching these attributes from created already Atlantis Terraform state file
  #
  # This assumes that you are the owner of these repositories and they are available at:
  # https://github.com/mygithubusername/awesome-repo and https://github.com/mygithubusername/another-awesome-repo
  atlantis_repo_allowlist = data.terraform_remote_state.atlantis.outputs.atlantis_repo_allowlist

  webhook_url    = element(data.terraform_remote_state.atlantis.outputs.github_webhook_urls, 0)
  webhook_secret = data.terraform_remote_state.atlantis.outputs.github_webhook_secret
}
