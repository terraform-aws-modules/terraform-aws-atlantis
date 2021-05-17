# Gitlab repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_project_hook.this](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_hook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_allowed_repo_names"></a> [atlantis\_allowed\_repo\_names](#input\_atlantis\_allowed\_repo\_names) | List of names of repositories which belong to the organization specified in `gitlab_organization` | `list(string)` | n/a | yes |
| <a name="input_create_gitlab_repository_webhook"></a> [create\_gitlab\_repository\_webhook](#input\_create\_gitlab\_repository\_webhook) | Whether to create Gitlab repository webhook for Atlantis | `bool` | `true` | no |
| <a name="input_gitlab_base_url"></a> [gitlab\_base\_url](#input\_gitlab\_base\_url) | Gitlab base\_url use | `string` | `""` | no |
| <a name="input_gitlab_token"></a> [gitlab\_token](#input\_gitlab\_token) | Gitlab token to use when creating webhook | `string` | `""` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_repository_webhook_secret"></a> [this\_repository\_webhook\_secret](#output\_this\_repository\_webhook\_secret) | Webhook secret |
| <a name="output_this_repository_webhook_urls"></a> [this\_repository\_webhook\_urls](#output\_this\_repository\_webhook\_urls) | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
