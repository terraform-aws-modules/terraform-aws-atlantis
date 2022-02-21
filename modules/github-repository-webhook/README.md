# Github repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | List of names of repositories which belong to the owner specified in `github_owner` | `list(string)` | n/a | yes |
| <a name="input_create_github_repository_webhook"></a> [create\_github\_repository\_webhook](#input\_create\_github\_repository\_webhook) | Whether to create Github repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_github_base_url"></a> [github\_base\_url](#input\_github\_base\_url) | Github base URL to use when creating webhook (when using GitHub Enterprise) | `string` | `null` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner to use when creating webhook | `string` | `""` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token to use when creating webhook | `string` | `""` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_webhook_secret"></a> [repository\_webhook\_secret](#output\_repository\_webhook\_secret) | Webhook secret |
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
