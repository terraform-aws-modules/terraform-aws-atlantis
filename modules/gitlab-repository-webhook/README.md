# gitlab repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_gitlab_repository_webhook | Whether to create gitlab repository webhook for Atlantis | string | `true` | no |
| gitlab_organization | gitlab organization to use when creating webhook | string | `` | no |
| atlantis_allowed_repo_names | List of names of repositories which belong to the organization specified in `gitlab_organization` | list | - | yes |
| gitlab_token | gitlab token to use when creating webhook | string | `` | no |
| webhook_secret | Webhook secret | string | `` | no |
| webhook_url | Webhook URL | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| this_repository_webhook_secret | Webhook secret |
| this_repository_webhook_urls | Webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
