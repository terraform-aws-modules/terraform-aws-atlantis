module "github_repository_webhook" {
  source = "../../modules/github-repository-webhook"

  github_token        = "dd77a64848dc3246c0e57cc0b46fa784ea066a56d"
  github_organization = "mygithubusername"

  // This assumes that you are the owner of these repositories and they are available at:
  // https://github.com/mygithubusername/awesome-repo and https://github.com/mygithubusername/another-awesome-repo
  github_repo_names = ["awesome-repo", "another-awesome-repo"]

  webhook_url    = "http://atlantis.acmecompany.com/events"
  webhook_secret = "1234567890SECRET"
}
