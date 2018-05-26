# Github repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_github_repository_webhook | Whether to create Github repository webhook for Atlantis | string | `true` | no |
| github_organization | Github organization to use when creating webhook | string | `` | no |
| github_repo_names | List of names of repositories which belong to the organization specified in `github_organization` | list | - | yes |
| github_token | Github token to use when creating webhook | string | `` | no |
| webhook_secret | Webhook secret | string | `` | no |
| webhook_url | Webhook URL | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| this_repository_webhook_secret | Webhook secret |
| this_repository_webhook_urls | Webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
