# Github repository webhook for Atlantis

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create Github repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | List of names of repositories which belong to the owner specified in `github_owner` | `list(string)` | `[]` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URL |
<!-- END_TF_DOCS -->
