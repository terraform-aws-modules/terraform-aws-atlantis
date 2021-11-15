# GitHub repository webhook for Atlantis

Configuration in this directory creates GitHub repository webhooks configured to Atlantis URL. This example uses value of webhook secret which got generated when Atlantis setup by referring to `terraform.tfstate`, so this example has to run after Atlantis.

GitHub's personal access token can be generated at https://github.com/settings/tokens

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and put your GitHub token and Github owner there or specify them using environment variables (`TF_VAR_github_token` and `TF_VAR_github_owner`). Once ready, execute:

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
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_repository_webhook"></a> [github\_repository\_webhook](#module\_github\_repository\_webhook) | ../../modules/github-repository-webhook | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.atlantis](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_webhook_secret"></a> [github\_webhook\_secret](#output\_github\_webhook\_secret) | Github webhook secret |
| <a name="output_github_webhook_urls"></a> [github\_webhook\_urls](#output\_github\_webhook\_urls) | Github webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
