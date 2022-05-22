# Bitbucket repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_bitbucket"></a> [bitbucket](#requirement\_bitbucket) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_bitbucket"></a> [bitbucket](#provider\_bitbucket) | >= 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [bitbucket_hook.this](https://registry.terraform.io/providers/DrFaust92/bitbucket/latest/docs/resources/hook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | List of names of repositories | `list(string)` | n/a | yes |
| <a name="input_bitbucket_owner"></a> [bitbucket\_owner](#input\_bitbucket\_owner) | Bitbucket owner to use when creating webhook | `string` | `""` | no |
| <a name="input_bitbucket_password"></a> [bitbucket\_password](#input\_bitbucket\_password) | Bitbucket App Password used to authenticate | `string` | `null` | no |
| <a name="input_bitbucket_username"></a> [bitbucket\_username](#input\_bitbucket\_username) | Bitbucket Username used to authneticate | `string` | `null` | no |
| <a name="input_create_bitbucket_repository_webhook"></a> [create\_bitbucket\_repository\_webhook](#input\_create\_bitbucket\_repository\_webhook) | Whether to create Bitbucket repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
