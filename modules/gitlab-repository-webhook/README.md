# Gitlab repository webhook for Atlantis

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_project_hook.this](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_hook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create Gitlab repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | List of names of repositories which belong to the `gitlab_base_url` specified | `list(string)` | `[]` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URL |
<!-- END_TF_DOCS -->
