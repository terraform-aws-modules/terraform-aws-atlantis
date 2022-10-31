# Complete Atlantis example with GitHub App and Webhooks

Configuration in this directory creates the necessary infrastructure and resources for running Atlantis on Fargate plus GitHub repository webhooks configured to Atlantis URL.

An existing Route53 hosted zone and domain is required to deploy this example.

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and update the values locally or specify them using environment variables (`TF_VAR_github_app_id=xxx`, `TF_VAR_github_owner=xxx`, etc.). Ensure that `bootstrap_github_app` is `true`.  Once ready, execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Terraform will output a URL to setup a new Github App via Atlantis, which should look something like https://$ATLANTIS_HOST/github-app/setup. Open that URL and go through the setup process. Before closing the window, click the link to install the new GitHub App on you repositories and copy the values `github_app_id`, `github_app_key`, and `github_webhook_secret` into `terraform.tfvars`. You should also set `bootstrap_github_app` to `false` . Now execute:

```bash
$ terraform plan
$ terraform apply

```

Note - if you receive the following error when running apply:

`Error: InvalidParameterException: The new ARN and resource ID format must be enabled to add tags to the service. Opt in to the new format and try again. "atlantiscomplete"`

Go to https://eu-west-1.console.aws.amazon.com/ecs/home?region=eu-west-1#/settings (update for your region of use) and change `Container instance`, `Service`, and `Task` to `Enabled`.

⚠️ This example will create resources which cost money. Run `terraform destroy` when you don't need these resources. ⚠️

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.69 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.69 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlantis"></a> [atlantis](#module\_atlantis) | ../../ | n/a |
| <a name="module_atlantis_access_log_bucket"></a> [atlantis\_access\_log\_bucket](#module\_atlantis\_access\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.atlantis_access_log_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing | `list(string)` | n/a | yes |
| <a name="input_bootstrap_github_app"></a> [bootstrap\_github\_app](#input\_bootstrap\_github\_app) | Flag to configure Atlantis to bootstrap a new Github App | `bool` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | GitHub App ID that is running the Atlantis command | `string` | n/a | yes |
| <a name="input_github_app_key"></a> [github\_app\_key](#input\_github\_app\_key) | The PEM encoded private key for the GitHub App | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner | `string` | n/a | yes |
| <a name="input_github_repo_names"></a> [github\_repo\_names](#input\_github\_repo\_names) | List of Github repositories that should be monitored by Atlantis | `list(string)` | n/a | yes |
| <a name="input_github_webhook_secret"></a> [github\_webhook\_secret](#input\_github\_webhook\_secret) | Webhook secret | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atlantis_github_app_setup_url"></a> [atlantis\_github\_app\_setup\_url](#output\_atlantis\_github\_app\_setup\_url) | URL to create a new Github App with Atlantis |
| <a name="output_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#output\_atlantis\_repo\_allowlist) | Git repositories where webhook should be created |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Task definition for ECS service (used for external triggers) |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The Atlantis ECS task role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
