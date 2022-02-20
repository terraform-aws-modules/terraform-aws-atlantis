# Complete Atlantis example with GitHub Webhooks

Configuration in this directory creates the necessary infrastructure and resources for running Atlantis on Fargate plus GitHub repository webhooks configured to Atlantis URL.

An existing Route53 hosted zone and domain is required to deploy this example.

GitHub's personal access token can be generated at https://github.com/settings/tokens

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.45 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.8 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlantis"></a> [atlantis](#module\_atlantis) | ../github-complete | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| <a name="input_enable_ephemeral_storage"></a> [enable\_ephemeral\_storage](#input\_enable\_ephemeral\_storage) | By default this example uses ephemeral storage | `bool` | `true` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token | `string` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | Github user for Atlantis to utilize when performing Github activities | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | `"github-complete"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy the resources | `string` | `"eu-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be applied to the resources | `map(any)` | <pre>{<br>  "Environment": "dev",<br>  "Owner": "user"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#output\_atlantis\_repo\_allowlist) | Git repositories where webhook should be created |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Task definition for ECS service (used for external triggers) |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The Atlantis ECS task role arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
