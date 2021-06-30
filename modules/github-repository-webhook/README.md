# Github repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_allowed_repo_names"></a> [atlantis\_allowed\_repo\_names](#input\_atlantis\_allowed\_repo\_names) | List of names of repositories which belong to the organization specified in `github_organization` | `list(string)` | n/a | yes |
| <a name="input_create_github_repository_webhook"></a> [create\_github\_repository\_webhook](#input\_create\_github\_repository\_webhook) | Whether to create Github repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Github organization to use when creating webhook | `string` | `""` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token to use when creating webhook | `string` | `""` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_repository_webhook_secret"></a> [this\_repository\_webhook\_secret](#output\_this\_repository\_webhook\_secret) | Webhook secret |
| <a name="output_this_repository_webhook_urls"></a> [this\_repository\_webhook\_urls](#output\_this\_repository\_webhook\_urls) | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
