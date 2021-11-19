# Gitlab repository webhook for Atlantis

Configuration in this directory creates Gitlab repository webhooks configured to Atlantis URL. This example uses value of webhook secret which got generated when Atlantis setup by referring to `terraform.tfstate`, so this example has to run after Atlantis.

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and put your GitHub token and Github owner there or specify them using environment variables (`TF_VAR_gitlab_token` and `TF_VAR_gitlab_base_url`). Once ready, execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gitlab_repository_webhook"></a> [gitlab\_repository\_webhook](#module\_gitlab\_repository\_webhook) | ../../modules/gitlab-repository-webhook | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.atlantis](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gitlab_base_url"></a> [gitlab\_base\_url](#input\_gitlab\_base\_url) | Gitlab base\_url | `string` | `""` | no |
| <a name="input_gitlab_token"></a> [gitlab\_token](#input\_gitlab\_token) | Gitlab token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gitlab_webhook_secret"></a> [gitlab\_webhook\_secret](#output\_gitlab\_webhook\_secret) | Gitlab webhook secret |
| <a name="output_gitlab_webhook_urls"></a> [gitlab\_webhook\_urls](#output\_gitlab\_webhook\_urls) | Gitlab webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
