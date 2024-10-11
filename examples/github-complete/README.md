# Complete GitHub example

Configuration in this directory provisions Atlantis on ECS with EFS storage, ALB, Route53 record and GitHub repository webhooks.

## Usage

To run this code you need to copy `terraform.tfvars.sample` into `terraform.tfvars` and update the values locally or specify them using environment variables (`TF_VAR_github_app_id=xxx`, `TF_VAR_github_owner=xxx`, etc.). Ensure that `bootstrap_github_app` is `true`.  Once ready, execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlantis"></a> [atlantis](#module\_atlantis) | ../../ | n/a |
| <a name="module_github_repository_webhooks"></a> [github\_repository\_webhooks](#module\_github\_repository\_webhooks) | ../../modules/github-repository-webhook | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | terraform-aws-modules/secrets-manager/aws | ~> 1.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [random_password.webhook_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_github_user"></a> [atlantis\_github\_user](#input\_atlantis\_github\_user) | GitHub user or organization name | `string` | n/a | yes |
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | List of GitHub repositories that Atlantis will be allowed to access | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | Github owner to use when creating webhook | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token to use when creating webhook | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | List of GitHub repositories to create webhooks for. This is just the name of the repository, excluding the user or organization | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | ALB created and all of its associated outputs |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | ECS cluster created and all of its associated outputs |
| <a name="output_efs"></a> [efs](#output\_efs) | EFS created and all of its associated outputs |
| <a name="output_service"></a> [service](#output\_service) | ECS service created and all of its associated |
<!-- END_TF_DOCS -->
