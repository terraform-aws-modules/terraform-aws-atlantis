# Complete Atlantis example with GitHub App and Webhooks

Configuration in this directory creates the necessary infrastructure and resources for running Atlantis on Fargate plus GitHub repository webhooks configured to Atlantis URL.

An existing Route53 hosted zone and domain is required to deploy this example.

The GitHub App can be generated using multiple methods:

- You can follow Atlantis instructions depicted [here](https://www.runatlantis.io/docs/access-credentials.html#github-app). The Atlantis method mostly automates the GitHub App generation using [GitHub App Manifest](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app-from-a-manifest), but you need an exposed endpoint to complete the process.
- The other method is to manually create the GitHub App as instructed [here](https://docs.github.com/en/developers/apps/building-github-apps/creating-a-github-app).

Once you have your GitHub App registered you will be able to access/manage the required parameters:

- `atlantis_github_app_id` to identify the GitHub app.
- `atlantis_github_app_key` to interact with GitHub.
- `atlantis_github_webhook_secret` to receive and validate incoming webhook invocations from GitHub.

## GitHub Personal Access Token (PAT) is no longer recommended

While still supported, the use of GitHub Personal Access Token (PAT) is no longer the recommended method in favor of GitHub App.

[GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps) provide more control over repository access/permissions and does not require the use of bot accounts.

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and update the values locally or specify them using environment variables (`TF_VAR_github_token=xxx`, `TF_VAR_github_owner=xxx`, etc.). Once ready, execute:

```bash
$ terraform init
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
| <a name="module_github_repository_webhook"></a> [github\_repository\_webhook](#module\_github\_repository\_webhook) | ../../modules/github-repository-webhook | n/a |

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
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | GitHub App ID that is running the Atlantis command | `string` | n/a | yes |
| <a name="input_github_app_key"></a> [github\_app\_key](#input\_github\_app\_key) | The PEM encoded private key for the GitHub App | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner | `string` | n/a | yes |
| <a name="input_github_repo_names"></a> [github\_repo\_names](#input\_github\_repo\_names) | List of Github repositories that should be monitored by Atlantis | `list(string)` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | Github user for Atlantis to utilize when performing Github activities | `string` | n/a | yes |
| <a name="input_github_webhook_secret"></a> [github\_webhook\_secret](#input\_github\_webhook\_secret) | Webhook secret | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#output\_atlantis\_repo\_allowlist) | Git repositories where webhook should be created |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Task definition for ECS service (used for external triggers) |
| <a name="output_github_webhook_secret"></a> [github\_webhook\_secret](#output\_github\_webhook\_secret) | Github webhook secret |
| <a name="output_github_webhook_urls"></a> [github\_webhook\_urls](#output\_github\_webhook\_urls) | Github webhook URL |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The Atlantis ECS task role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
