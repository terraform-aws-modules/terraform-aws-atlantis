# Bitbucket repository webhook for Atlantis

Configuration in this directory creates Bitbucket repository webhooks configured to Atlantis URL. This example uses value of webhook secret which got generated when Atlantis setup by referring to `terraform.tfstate`, so this example has to run after Atlantis.

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
| <a name="requirement_bitbucket"></a> [bitbucket](#requirement\_bitbucket) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bitbucket_repository_webhook"></a> [bitbucket\_repository\_webhook](#module\_bitbucket\_repository\_webhook) | ../../modules/bitbucket-repository-webhook | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.atlantis](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_owner"></a> [bitbucket\_owner](#input\_bitbucket\_owner) | Bitbucket owner(or org) | `string` | `""` | no |
| <a name="input_bitbucket_password"></a> [bitbucket\_password](#input\_bitbucket\_password) | Bitbucket App Password used to authenticate | `string` | `""` | no |
| <a name="input_bitbucket_username"></a> [bitbucket\_username](#input\_bitbucket\_username) | Bitbucket Username used to authneticate | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bitbucket_webhook_urls"></a> [bitbucket\_webhook\_urls](#output\_bitbucket\_webhook\_urls) | Gitlab webhook URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
