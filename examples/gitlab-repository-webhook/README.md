# Gitlab repository webhook for Atlantis

Configuration in this directory creates Gitlab repository webhooks configured to Atlantis URL. This example uses value of webhook secret which got generated when Atlantis setup by referring to `terraform.tfstate`, so this example has to run after Atlantis. 

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and put your GitHub token and Github organization there or specify them using environment variables (`TF_VAR_gitlab_token` and `TF_VAR_gitlab_base_url`). Once ready, execute:

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
| gitlab\_base\_url | Gitlab base_url | string | `""` | no |
| gitlab\_token | Gitlab token | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gitlab\_webhook\_secret | Gitlab webhook secret |
| gitlab\_webhook\_urls | Gitlab webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
