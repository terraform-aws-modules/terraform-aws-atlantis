# Bitbucket repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_Bitbucket"></a> [Bitbucket](#requirement\_Bitbucket) | >= 4.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_Bitbucket"></a> [Bitbucket](#provider\_Bitbucket) | >= 4.8 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [Bitbucket_repository_webhook.this](https://registry.terraform.io/providers/integrations/Bitbucket/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | List of names of repositories which belong to the owner specified in `Bitbucket_owner` | `list(string)` | n/a | yes |
| <a name="input_create_Bitbucket_repository_webhook"></a> [create\_Bitbucket\_repository\_webhook](#input\_create\_Bitbucket\_repository\_webhook) | Whether to create Bitbucket repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_Bitbucket_base_url"></a> [Bitbucket\_base\_url](#input\_Bitbucket\_base\_url) | Bitbucket base URL to use when creating webhook (when using Bitbucket Enterprise) | `string` | `null` | no |
| <a name="input_Bitbucket_owner"></a> [Bitbucket\_owner](#input\_Bitbucket\_owner) | Bitbucket owner to use when creating webhook | `string` | `""` | no |
| <a name="input_Bitbucket_token"></a> [Bitbucket\_token](#input\_Bitbucket\_token) | Bitbucket token to use when creating webhook | `string` | `""` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_webhook_secret"></a> [repository\_webhook\_secret](#output\_repository\_webhook\_secret) | Webhook secret |
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
