# GitHub repository webhook for Atlantis

Configuration in this directory creates GitHub repository webhooks configured to Atlantis URL. This example uses value of webhook secret which got generated when Atlantis setup by referring to `terraform.tfstate`, so this example has to run after Atlantis. 

GitHub's personal access token can be generated at https://github.com/settings/tokens 

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and put your GitHub token and Github organization there or specify them using environment variables (`TF_VAR_github_token` and `TF_VAR_github_organization`). Once ready, execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| github\_organization | Github organization | string | n/a | yes |
| github\_token | Github token | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| github\_webhook\_secret | Github webhook secret |
| github\_webhook\_urls | Github webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
