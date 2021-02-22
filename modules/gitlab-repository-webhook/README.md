# Gitlab repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| gitlab | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| gitlab | >= 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [gitlab_project_hook](https://registry.terraform.io/providers/gitlabhq/gitlab/3.0/docs/resources/project_hook) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| atlantis\_allowed\_repo\_names | List of names of repositories which belong to the organization specified in `gitlab_organization` | `list(string)` | n/a | yes |
| create\_gitlab\_repository\_webhook | Whether to create Gitlab repository webhook for Atlantis | `bool` | `true` | no |
| gitlab\_base\_url | Gitlab base\_url use | `string` | `""` | no |
| gitlab\_token | Gitlab token to use when creating webhook | `string` | `""` | no |
| webhook\_secret | Webhook secret | `string` | `""` | no |
| webhook\_url | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_repository\_webhook\_secret | Webhook secret |
| this\_repository\_webhook\_urls | Webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
