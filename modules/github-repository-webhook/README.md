# Github repository webhook for Atlantis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| github | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| atlantis\_allowed\_repo\_names | List of names of repositories which belong to the organization specified in `github_organization` | `list(string)` | n/a | yes |
| create\_github\_repository\_webhook | Whether to create Github repository webhook for Atlantis | `bool` | `true` | no |
| github\_organization | Github organization to use when creating webhook | `string` | `""` | no |
| github\_token | Github token to use when creating webhook | `string` | `""` | no |
| webhook\_secret | Webhook secret | `string` | `""` | no |
| webhook\_url | Webhook URL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_repository\_webhook\_secret | Webhook secret |
| this\_repository\_webhook\_urls | Webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
