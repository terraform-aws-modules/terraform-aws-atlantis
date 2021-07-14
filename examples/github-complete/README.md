# Complete Atlantis example with GitHub Webhooks

Configuration in this directory creates the necessary infrastructure and resources for running Atlantis on Fargate plus GitHub repository webhooks configured to Atlantis URL.

An existing Route53 hosted zone and domain is required to deploy this example.

GitHub's personal access token can be generated at https://github.com/settings/tokens

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and update the values locally or specify them using environment variables (`TF_VAR_github_token=xxx`, `TF_VAR_github_organization=xxx`, etc.). Once ready, execute:

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.68 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.68 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlantis"></a> [atlantis](#module\_atlantis) | ../../ |  |
| <a name="module_atlantis_access_log_bucket"></a> [atlantis\_access\_log\_bucket](#module\_atlantis\_access\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | >= 1.9 |
| <a name="module_github_repository_webhook"></a> [github\_repository\_webhook](#module\_github\_repository\_webhook) | ../../modules/github-repository-webhook |  |

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
| <a name="input_allowed_repo_names"></a> [allowed\_repo\_names](#input\_allowed\_repo\_names) | Repositories that Atlantis will listen for events from and a webhook will be installed | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Github organization | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token | `string` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | Github user for Atlantis to utilize when performing Github activities | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | A list of  users or roles, that can assume the task role | `list(string)` | `[]` | no |
| <a name="input_trusted_principals"></a> [trusted\_principals](#input\_trusted\_principals) | A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atlantis_allowed_repo_names"></a> [atlantis\_allowed\_repo\_names](#output\_atlantis\_allowed\_repo\_names) | Git repositories where webhook should be created |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Task definition for ECS service (used for external triggers) |
| <a name="output_github_webhook_secret"></a> [github\_webhook\_secret](#output\_github\_webhook\_secret) | Github webhook secret |
| <a name="output_github_webhook_urls"></a> [github\_webhook\_urls](#output\_github\_webhook\_urls) | Github webhook URL |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The Atlantis ECS task role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
