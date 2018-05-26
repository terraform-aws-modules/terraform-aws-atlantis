# GitHub repository webhook for Atlantis

Configuration in this directory creates GitHub repository webhooks configured to Atlantis URL.

GitHub's personal access token can be generated at https://github.com/settings/tokens

## Usage

To run this example you need to customize values of your GitHub token and Github organization inside `main.tf` and then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Outputs

| Name | Description |
|------|-------------|
| github_webhook_secret | Github webhook secret |
| github_webhook_urls | Github webhook URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
