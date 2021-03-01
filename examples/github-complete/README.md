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
| terraform | >= 0.13 |
| aws | >= 2.68 |
| github | >= 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| atlantis | ../../ |  |
| atlantis_access_log_bucket | terraform-aws-modules/s3-bucket/aws | >= 1.9 |
| github_repository_webhook | ../../modules/github-repository-webhook |  |

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_elb_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing | `list(string)` | n/a | yes |
| allowed\_repo\_names | Repositories that Atlantis will listen for events from and a webhook will be installed | `list(string)` | n/a | yes |
| domain | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| github\_organization | Github organization | `string` | n/a | yes |
| github\_token | Github token | `string` | n/a | yes |
| github\_user | Github user for Atlantis to utilize when performing Github activities | `string` | n/a | yes |
| region | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| trusted\_principals | A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| atlantis\_allowed\_repo\_names | Git repositories where webhook should be created |
| atlantis\_url | URL of Atlantis |
| ecs\_task\_definition | Task definition for ECS service (used for external triggers) |
| github\_webhook\_secret | Github webhook secret |
| github\_webhook\_urls | Github webhook URL |
| task\_role\_arn | The Atlantis ECS task role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
