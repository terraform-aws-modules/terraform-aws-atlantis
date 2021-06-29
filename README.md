# AWS Terraform module which runs Atlantis on AWS Fargate

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub, GitLab and Bitbucket Cloud.

This repository contains Terraform infrastructure code which creates AWS resources required to run [Atlantis](https://www.runatlantis.io/) on AWS, including:

- Virtual Private Cloud (VPC)
- SSL certificate using Amazon Certificate Manager (ACM)
- Application Load Balancer (ALB)
- Domain name using AWS Route53 which points to ALB
- [AWS Elastic Cloud Service (ECS)](https://aws.amazon.com/ecs/) and [AWS Fargate](https://aws.amazon.com/fargate/) running Atlantis Docker image
- AWS Parameter Store to keep secrets and access them in ECS task natively

[AWS Fargate](https://aws.amazon.com/fargate/) with optional support for [Fargate Spot](https://aws.amazon.com/blogs/aws/aws-fargate-spot-now-generally-available/) is used to reduce the bill, and it is also a cool AWS service.

Depending on which SCM system you use, Github repositories or Gitlab projects has to be configured to post events to Atlantis webhook URL.

See `README.md` in `examples` for Github or Gitlab for complete details.

### Before using Atlantis and the code in this repository please make sure that you have read and understood the security implications described in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html).

## How to use this?

As often with the code published in [terraform-aws-modules GitHub organization](https://github.com/terraform-aws-modules) you should have everything to run this code and get Atlantis up and running.

There are three ways to do this:

1. [As a standalone project](https://github.com/terraform-aws-modules/terraform-aws-atlantis#run-atlantis-as-a-standalone-project)
1. [As a Terraform module](https://github.com/terraform-aws-modules/terraform-aws-atlantis#run-atlantis-as-a-terraform-module)
1. [As a part of an existing AWS infrastructure](https://github.com/terraform-aws-modules/terraform-aws-atlantis#run-atlantis-as-a-part-of-an-existing-aws-infrastructure-use-existing-vpc)

### Run Atlantis as a standalone project

1. Clone this github repository:

```
$ git clone git@github.com:terraform-aws-modules/terraform-aws-atlantis.git
$ cd terraform-aws-atlantis
```

2. Copy sample `terraform.tfvars.sample` into `terraform.tfvars` and specify required variables there.

3. Run `terraform init` to download required providers and modules.

4. Run `terraform apply` to apply the Terraform configuration and create required infrastructure.

5. Run `terraform output atlantis_url` to get URL where Atlantis is publicly reachable. (Note: It may take a minute or two to get it reachable for the first time)

6. Github webhook is automatically created if `github_token`, `github_organization` and `github_repo_names` were specified. Read [Add GitHub Webhook](https://github.com/runatlantis/atlantis#add-github-webhook) in the official Atlantis documentation or check [example "GitHub repository webhook for Atlantis"](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-repository-webhook) to add more webhooks.

### Run Atlantis as a Terraform module

This way allows integration with your existing Terraform configurations.

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "~> 2.0"

  name = "atlantis"

  # VPC
  cidr            = "10.20.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

  # DNS (without trailing dot)
  route53_zone_name = "example.com"

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  certificate_arn = "arn:aws:acm:eu-west-1:135367859851:certificate/70e008e1-c0e1-4c7e-9670-7bb5bd4f5a84"

  # Atlantis
  atlantis_github_user       = "atlantis-bot"
  atlantis_github_user_token = "examplegithubtoken"
  atlantis_repo_allowlist    = ["github.com/terraform-aws-modules/*"]
}
```

### Provide Atlantis with server yaml configuration

`server-atlantis.yaml`
```yaml
repos:
  - id: /.*/
    allow_custom_workflows: true
    allowed_overrides:
      - apply_requirements
      - workflow
    apply_requirements:
      - approved
    workflow: default
```

`main.tf`
```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  # ...

  custom_environment_variables = [
    {
      "name" : "ATLANTIS_REPO_CONFIG_JSON",
      "value" : jsonencode(yamldecode(file("${path.module}/server-atlantis.yaml"))),
    },
  ]

  # ...
}
```

### Run Atlantis as a part of an existing AWS infrastructure (use existing VPC)

This way allows integration with your existing AWS resources - VPC, public and private subnets. Specify the following arguments (see methods described above):

```
vpc_id             = "vpc-1651acf1"
private_subnet_ids = ["subnet-1fe3d837", "subnet-129d66ab"]
public_subnet_ids  = ["subnet-1211eef5", "subnet-163466ab"]
```

If `vpc_id` is specified it will take precedence over `cidr` and existing VPC will be used. `private_subnet_ids` and `public_subnet_ids` must be specified also.

Make sure that both private and public subnets were created in the same set of availability zones (ALB will be created in public subnets, ECS Fargate service in private subnets).

If all provided subnets are public (no NAT gateway) then `ecs_service_assign_public_ip` should be set to `true`.

### Secure Atlantis with ALB Built-in Authentication

#### OpenID Connect (OIDC)

You can use service like [Auth0](https://www.auth0.com) to secure access to Atlantis and require authentication on ALB. To enable this, you need to create Auth0 application and provide correct arguments to Atlantis module. Make sure to update application hostname, client id and client secret:

Read more in [this post](https://medium.com/@sandrinodm/securing-your-applications-with-aws-alb-built-in-authentication-and-auth0-310ad84c8595).

##### Auth0

```hcl
alb_authenticate_oidc = {
  issuer                              = "https://youruser.eu.auth0.com/"
  token_endpoint                      = "https://youruser.eu.auth0.com/oauth/token"
  user_info_endpoint                  = "https://youruser.eu.auth0.com/userinfo"
  authorization_endpoint              = "https://youruser.eu.auth0.com/authorize"
  authentication_request_extra_params = {}
  client_id                           = "clientid"
  client_secret                       = "secret123" # a data source would be good here
}
```

##### Okta

```hcl
alb_authenticate_oidc = {
  issuer                              = "https://dev-42069.okta.com/"
  token_endpoint                      = "https://dev-42069.okta.com/oauth2/v1/token"
  user_info_endpoint                  = "https://dev-42069.okta.com/oauth2/v1/userinfo"
  authorization_endpoint              = "https://dev-42069.okta.com/oauth2/v1/authorize"
  authentication_request_extra_params = {}
  client_id                           = "clientid"
  client_secret                       = "secret123" # a data source would be good here
}
```

Read more in [this post](https://medium.com/swlh/aws-alb-authentication-with-okta-oidc-using-terraform-902cd8289db4)

#### AWS Cognito with SAML

The AWS Cognito service allows you to define SAML applications tied to an identity provider (e.g., GSuite). The Atlantis ALB can then be configured to require an authenticated user managed by your identity provider.

To configure AWS Cognito connecting to a GSuite SAML application, you can use the [gsuite-saml-cognito](https://github.com/alloy-commons/alloy-open-source/tree/master/terraform-modules/gsuite-saml-cognito#example-usage) Terraform module.

To enable Cognito authentication on the Atlantis ALB, specify the following arguments containing attributes from your Cognito configuration.

```hcl
alb_authenticate_cognito = {
  user_pool_arn       = "arn:aws:cognito-idp:us-west-2:1234567890:userpool/us-west-2_aBcDeFG"
  user_pool_client_id = "clientid123"
  user_pool_domain    = "sso.your-corp.com"
}
```

#### Allow GitHub Webhooks Unauthenticated Access

If you are using one of the authentication methods above along with managed GitHub (not self-hosted enterprise version), you'll need to allow unauthenticated access to GitHub's Webhook static IPs:

```hcl
allow_unauthenticated_access = true
allow_github_webhooks        = true
```

## Notes

1. AWS Route53 zone is not created by this module, so zone specified as a value in `route53_zone_name` should be created before using this module. Check documentation for [aws_route53_zone](https://www.terraform.io/docs/providers/aws/r/route53_zone.html).
1. Currently this module configures Atlantis in a way that it can not be used to work with GitHub and Gitlab simultaneously (can't make list of ECS secrets conditionally).
1. For Bitbucket Cloud webhook configuration follow instructions in [the official Atlantis documentation](https://www.runatlantis.io/docs/configuring-webhooks.html#bitbucket-cloud-bitbucket-org-webhook).

<!-- TODO: For Bitbucket Cloud an IP whitelist should be implemented for the webhook url as stated in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html#bitbucket-cloud-bitbucket-org) due to lack of support for webhook secrets. -->

## Examples

- [Complete Atlantis with GitHub webhook](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-complete)
- [GitHub repository webhook for Atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-repository-webhook)
- [GitLab repository webhook for Atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/gitlab-repository-webhook)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.68 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.68 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | v2.12.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | v5.10.0 |
| <a name="module_alb_http_sg"></a> [alb\_http\_sg](#module\_alb\_http\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | v3.17.0 |
| <a name="module_alb_https_sg"></a> [alb\_https\_sg](#module\_alb\_https\_sg) | terraform-aws-modules/security-group/aws//modules/https-443 | v3.17.0 |
| <a name="module_atlantis_sg"></a> [atlantis\_sg](#module\_atlantis\_sg) | terraform-aws-modules/security-group/aws | v3.17.0 |
| <a name="module_container_definition_bitbucket"></a> [container\_definition\_bitbucket](#module\_container\_definition\_bitbucket) | cloudposse/ecs-container-definition/aws | v0.45.2 |
| <a name="module_container_definition_github_gitlab"></a> [container\_definition\_github\_gitlab](#module\_container\_definition\_github\_gitlab) | cloudposse/ecs-container-definition/aws | v0.45.2 |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | v2.5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | v2.64.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_access_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener_rule.unauthenticated_access_for_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_route53_record.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ssm_parameter.atlantis_bitbucket_user_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.atlantis_github_user_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.atlantis_gitlab_user_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_id.webhook](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ecs_task_definition.atlantis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |
| [aws_iam_policy_document.ecs_task_access_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_access_secrets_with_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_domain_name"></a> [acm\_certificate\_domain\_name](#input\_acm\_certificate\_domain\_name) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | `string` | `""` | no |
| <a name="input_alb_authenticate_cognito"></a> [alb\_authenticate\_cognito](#input\_alb\_authenticate\_cognito) | Map of AWS Cognito authentication parameters to protect ALB (eg, using SAML). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-cognito-action | `any` | `{}` | no |
| <a name="input_alb_authenticate_oidc"></a> [alb\_authenticate\_oidc](#input\_alb\_authenticate\_oidc) | Map of Authenticate OIDC parameters to protect ALB (eg, using Auth0). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-oidc-action | `any` | `{}` | no |
| <a name="input_alb_drop_invalid_header_fields"></a> [alb\_drop\_invalid\_header\_fields](#input\_alb\_drop\_invalid\_header\_fields) | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `null` | no |
| <a name="input_alb_enable_deletion_protection"></a> [alb\_enable\_deletion\_protection](#input\_alb\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `null` | no |
| <a name="input_alb_http_security_group_tags"></a> [alb\_http\_security\_group\_tags](#input\_alb\_http\_security\_group\_tags) | Additional tags to put on the http security group | `map(string)` | `{}` | no |
| <a name="input_alb_https_security_group_tags"></a> [alb\_https\_security\_group\_tags](#input\_alb\_https\_security\_group\_tags) | Additional tags to put on the https security group | `map(string)` | `{}` | no |
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules of the ALB. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_alb_listener_ssl_policy_default"></a> [alb\_listener\_ssl\_policy\_default](#input\_alb\_listener\_ssl\_policy\_default) | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_alb_log_bucket_name"></a> [alb\_log\_bucket\_name](#input\_alb\_log\_bucket\_name) | S3 bucket (externally created) for storing load balancer access logs. Required if alb\_logging\_enabled is true. | `string` | `""` | no |
| <a name="input_alb_log_location_prefix"></a> [alb\_log\_location\_prefix](#input\_alb\_log\_location\_prefix) | S3 prefix within the log\_bucket\_name under which logs are stored. | `string` | `""` | no |
| <a name="input_alb_logging_enabled"></a> [alb\_logging\_enabled](#input\_alb\_logging\_enabled) | Controls if the ALB will log requests to S3. | `bool` | `false` | no |
| <a name="input_allow_github_webhooks"></a> [allow\_github\_webhooks](#input\_allow\_github\_webhooks) | Whether to allow access for GitHub webhooks | `bool` | `false` | no |
| <a name="input_allow_repo_config"></a> [allow\_repo\_config](#input\_allow\_repo\_config) | When true allows the use of atlantis.yaml config files within the source repos. | `string` | `"false"` | no |
| <a name="input_allow_unauthenticated_access"></a> [allow\_unauthenticated\_access](#input\_allow\_unauthenticated\_access) | Whether to create ALB listener rule to allow unauthenticated access for certain CIDR blocks (eg. allow GitHub webhooks to bypass OIDC authentication) | `bool` | `false` | no |
| <a name="input_allow_unauthenticated_access_priority"></a> [allow\_unauthenticated\_access\_priority](#input\_allow\_unauthenticated\_access\_priority) | ALB listener rule priority for allow unauthenticated access rule | `number` | `10` | no |
| <a name="input_atlantis_allowed_repo_names"></a> [atlantis\_allowed\_repo\_names](#input\_atlantis\_allowed\_repo\_names) | Git repositories where webhook should be created | `list(string)` | `[]` | no |
| <a name="input_atlantis_bitbucket_base_url"></a> [atlantis\_bitbucket\_base\_url](#input\_atlantis\_bitbucket\_base\_url) | Base URL of Bitbucket Server, use for Bitbucket on prem (Stash) | `string` | `""` | no |
| <a name="input_atlantis_bitbucket_user"></a> [atlantis\_bitbucket\_user](#input\_atlantis\_bitbucket\_user) | Bitbucket username that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_bitbucket_user_token"></a> [atlantis\_bitbucket\_user\_token](#input\_atlantis\_bitbucket\_user\_token) | Bitbucket token of the user that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_bitbucket_user_token_ssm_parameter_name"></a> [atlantis\_bitbucket\_user\_token\_ssm\_parameter\_name](#input\_atlantis\_bitbucket\_user\_token\_ssm\_parameter\_name) | Name of SSM parameter to keep atlantis\_bitbucket\_user\_token | `string` | `"/atlantis/bitbucket/user/token"` | no |
| <a name="input_atlantis_fqdn"></a> [atlantis\_fqdn](#input\_atlantis\_fqdn) | FQDN of Atlantis to use. Set this only to override Route53 and ALB's DNS name. | `string` | `null` | no |
| <a name="input_atlantis_github_user"></a> [atlantis\_github\_user](#input\_atlantis\_github\_user) | GitHub username that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_github_user_token"></a> [atlantis\_github\_user\_token](#input\_atlantis\_github\_user\_token) | GitHub token of the user that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_github_user_token_ssm_parameter_name"></a> [atlantis\_github\_user\_token\_ssm\_parameter\_name](#input\_atlantis\_github\_user\_token\_ssm\_parameter\_name) | Name of SSM parameter to keep atlantis\_github\_user\_token | `string` | `"/atlantis/github/user/token"` | no |
| <a name="input_atlantis_github_webhook_secret"></a> [atlantis\_github\_webhook\_secret](#input\_atlantis\_github\_webhook\_secret) | GitHub webhook secret of an app that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_gitlab_hostname"></a> [atlantis\_gitlab\_hostname](#input\_atlantis\_gitlab\_hostname) | Gitlab server hostname, defaults to gitlab.com | `string` | `"gitlab.com"` | no |
| <a name="input_atlantis_gitlab_user"></a> [atlantis\_gitlab\_user](#input\_atlantis\_gitlab\_user) | Gitlab username that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_gitlab_user_token"></a> [atlantis\_gitlab\_user\_token](#input\_atlantis\_gitlab\_user\_token) | Gitlab token of the user that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_gitlab_user_token_ssm_parameter_name"></a> [atlantis\_gitlab\_user\_token\_ssm\_parameter\_name](#input\_atlantis\_gitlab\_user\_token\_ssm\_parameter\_name) | Name of SSM parameter to keep atlantis\_gitlab\_user\_token | `string` | `"/atlantis/gitlab/user/token"` | no |
| <a name="input_atlantis_hide_prev_plan_comments"></a> [atlantis\_hide\_prev\_plan\_comments](#input\_atlantis\_hide\_prev\_plan\_comments) | Enables atlantis server --hide-prev-plan-comments hiding previous plan comments on update | `string` | `"false"` | no |
| <a name="input_atlantis_image"></a> [atlantis\_image](#input\_atlantis\_image) | Docker image to run Atlantis with. If not specified, official Atlantis image will be used | `string` | `""` | no |
| <a name="input_atlantis_log_level"></a> [atlantis\_log\_level](#input\_atlantis\_log\_level) | Log level that Atlantis will run with. Accepted values are: <debug\|info\|warn\|error> | `string` | `"debug"` | no |
| <a name="input_atlantis_port"></a> [atlantis\_port](#input\_atlantis\_port) | Local port Atlantis should be running on. Default value is most likely fine. | `number` | `4141` | no |
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | List of allowed repositories Atlantis can be used with | `list(string)` | n/a | yes |
| <a name="input_atlantis_security_group_tags"></a> [atlantis\_security\_group\_tags](#input\_atlantis\_security\_group\_tags) | Additional tags to put on the atlantis security group | `map(string)` | `{}` | no |
| <a name="input_atlantis_version"></a> [atlantis\_version](#input\_atlantis\_version) | Verion of Atlantis to run. If not specified latest will be used | `string` | `"latest"` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list(string)` | `[]` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | `string` | `""` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Retention period of Atlantis CloudWatch logs | `number` | `7` | no |
| <a name="input_command"></a> [command](#input\_command) | The command that is passed to the container | `list(string)` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | The number of cpu units used by the atlantis container. If not specified ecs\_task\_cpu will be used | `number` | `null` | no |
| <a name="input_container_depends_on"></a> [container\_depends\_on](#input\_container\_depends\_on) | The dependencies defined for container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The condition can be one of START, COMPLETE, SUCCESS or HEALTHY | <pre>list(object({<br>    containerName = string<br>    condition     = string<br>  }))</pre> | `null` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | The amount (in MiB) of memory used by the atlantis container. If not specified ecs\_task\_memory will be used | `number` | `null` | no |
| <a name="input_container_memory_reservation"></a> [container\_memory\_reservation](#input\_container\_memory\_reservation) | The amount of memory (in MiB) to reserve for the container | `number` | `128` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Whether to create Route53 record for Atlantis | `bool` | `true` | no |
| <a name="input_custom_container_definitions"></a> [custom\_container\_definitions](#input\_custom\_container\_definitions) | A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used. | `string` | `""` | no |
| <a name="input_custom_environment_secrets"></a> [custom\_environment\_secrets](#input\_custom\_environment\_secrets) | List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`) | <pre>list(object(<br>    {<br>      name      = string<br>      valueFrom = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_custom_environment_variables"></a> [custom\_environment\_variables](#input\_custom\_environment\_variables) | List of additional environment variables the container will use (list should contain maps with `name` and `value`) | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_docker_labels"></a> [docker\_labels](#input\_docker\_labels) | The configuration options to send to the `docker_labels` | `map(string)` | `null` | no |
| <a name="input_ecs_container_insights"></a> [ecs\_container\_insights](#input\_ecs\_container\_insights) | Controls if ECS Cluster has container insights enabled | `bool` | `false` | no |
| <a name="input_ecs_fargate_spot"></a> [ecs\_fargate\_spot](#input\_ecs\_fargate\_spot) | Whether to run ECS Fargate Spot or not | `bool` | `false` | no |
| <a name="input_ecs_service_assign_public_ip"></a> [ecs\_service\_assign\_public\_ip](#input\_ecs\_service\_assign\_public\_ip) | Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html) | `bool` | `false` | no |
| <a name="input_ecs_service_deployment_maximum_percent"></a> [ecs\_service\_deployment\_maximum\_percent](#input\_ecs\_service\_deployment\_maximum\_percent) | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| <a name="input_ecs_service_deployment_minimum_healthy_percent"></a> [ecs\_service\_deployment\_minimum\_healthy\_percent](#input\_ecs\_service\_deployment\_minimum\_healthy\_percent) | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `50` | no |
| <a name="input_ecs_service_desired_count"></a> [ecs\_service\_desired\_count](#input\_ecs\_service\_desired\_count) | The number of instances of the task definition to place and keep running | `number` | `1` | no |
| <a name="input_ecs_service_enable_execute_command"></a> [ecs\_service\_enable\_execute\_command](#input\_ecs\_service\_enable\_execute\_command) | Enable ECS exec for the service. This can be used to allow interactive sessions and commands to be executed in the container | `bool` | `true` | no |
| <a name="input_ecs_service_force_new_deployment"></a> [ecs\_service\_force\_new\_deployment](#input\_ecs\_service\_force\_new\_deployment) | Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. myimage:latest) | `bool` | `false` | no |
| <a name="input_ecs_service_platform_version"></a> [ecs\_service\_platform\_version](#input\_ecs\_service\_platform\_version) | The platform version on which to run your service | `string` | `"LATEST"` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of cpu units used by the task | `number` | `256` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `number` | `512` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Specifies whether to enable Amazon ECS managed tags for the tasks within the service | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | The entry point that is passed to the container | `list(string)` | `null` | no |
| <a name="input_essential"></a> [essential](#input\_essential) | Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value | `bool` | `true` | no |
| <a name="input_external_task_definition_updates"></a> [external\_task\_definition\_updates](#input\_external\_task\_definition\_updates) | Enable to allow the task definition to be updated outside of this Terraform module. This should be enabled when using a deployment tool such as ecs-deploy which updates the task definition and will then keep the ECS service using the latest version of the task definition. | `bool` | `false` | no |
| <a name="input_extra_container_definitions"></a> [extra\_container\_definitions](#input\_extra\_container\_definitions) | A list of valid container definitions provided as a single valid JSON document. These will be provided as supplimentary to the main Atlantis container definition | `list(any)` | `[]` | no |
| <a name="input_firelens_configuration"></a> [firelens\_configuration](#input\_firelens\_configuration) | The FireLens configuration for the container. This is used to specify and configure a log router for container logs. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html | <pre>object({<br>    type    = string<br>    options = map(string)<br>  })</pre> | `null` | no |
| <a name="input_github_webhooks_cidr_blocks"></a> [github\_webhooks\_cidr\_blocks](#input\_github\_webhooks\_cidr\_blocks) | List of CIDR blocks used by GitHub webhooks | `list(string)` | <pre>[<br>  "140.82.112.0/20",<br>  "185.199.108.0/22",<br>  "192.30.252.0/22"<br>]</pre> | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the load balancer is internal or external | `bool` | `false` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use on all resources created (VPC, ALB, etc) | `string` | `"atlantis"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | `null` | no |
| <a name="input_policies_arn"></a> [policies\_arn](#input\_policies\_arn) | A list of the ARN of the policies you want to apply | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"<br>]</pre> | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of IDs of existing private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK\_DEFINITION | `string` | `null` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | A list of IDs of existing public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_readonly_root_filesystem"></a> [readonly\_root\_filesystem](#input\_readonly\_root\_filesystem) | Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value | `bool` | `false` | no |
| <a name="input_repository_credentials"></a> [repository\_credentials](#input\_repository\_credentials) | Container repository credentials; required when using a private repo.  This map currently supports a single key; "credentialsParameter", which should be the ARN of a Secrets Manager's secret holding the credentials | `map(string)` | `null` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 zone name to create ACM certificate in and main A-record, without trailing dot | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_ssm_kms_key_arn"></a> [ssm\_kms\_key\_arn](#input\_ssm\_kms\_key\_arn) | ARN of KMS key to use for encryption and decryption of SSM Parameters. Required only if your key uses a custom KMS key and not the default key | `string` | `""` | no |
| <a name="input_start_timeout"></a> [start\_timeout](#input\_start\_timeout) | Time duration (in seconds) to wait before giving up on resolving dependencies for a container | `number` | `30` | no |
| <a name="input_stop_timeout"></a> [stop\_timeout](#input\_stop\_timeout) | Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | A list of  users or roles, that can assume the task role | `list(string)` | `[]` | no |
| <a name="input_trusted_principals"></a> [trusted\_principals](#input\_trusted\_principals) | A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role | `list(string)` | `[]` | no |
| <a name="input_ulimits"></a> [ulimits](#input\_ulimits) | Container ulimit settings. This is a list of maps, where each map should contain "name", "hardLimit" and "softLimit" | <pre>list(object({<br>    name      = string<br>    hardLimit = number<br>    softLimit = number<br>  }))</pre> | `null` | no |
| <a name="input_use_ecs_old_arn_format"></a> [use\_ecs\_old\_arn\_format](#input\_use\_ecs\_old\_arn\_format) | A flag to enable/disable tagging the ecs resources that require the new longer arn format | `bool` | `false` | no |
| <a name="input_user"></a> [user](#input\_user) | The user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group. The default (null) will use the container's configured `USER` directive or root if not set. | `string` | `null` | no |
| <a name="input_volumes_from"></a> [volumes\_from](#input\_volumes\_from) | A list of VolumesFrom maps which contain "sourceContainer" (name of the container that has the volumes to mount) and "readOnly" (whether the container can write to the volume) | <pre>list(object({<br>    sourceContainer = string<br>    readOnly        = bool<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of an existing VPC where resources will be created | `string` | `""` | no |
| <a name="input_webhook_ssm_parameter_name"></a> [webhook\_ssm\_parameter\_name](#input\_webhook\_ssm\_parameter\_name) | Name of SSM parameter to keep webhook secret | `string` | `"/atlantis/webhook/secret"` | no |
| <a name="input_whitelist_unauthenticated_cidr_blocks"></a> [whitelist\_unauthenticated\_cidr\_blocks](#input\_whitelist\_unauthenticated\_cidr\_blocks) | List of allowed CIDR blocks to bypass authentication | `list(string)` | `[]` | no |
| <a name="input_working_directory"></a> [working\_directory](#input\_working\_directory) | The working directory to run commands inside the container | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Dns name of alb |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | Zone ID of alb |
| <a name="output_atlantis_allowed_repo_names"></a> [atlantis\_allowed\_repo\_names](#output\_atlantis\_allowed\_repo\_names) | Git repositories where webhook should be created |
| <a name="output_atlantis_url"></a> [atlantis\_url](#output\_atlantis\_url) | URL of Atlantis |
| <a name="output_atlantis_url_events"></a> [atlantis\_url\_events](#output\_atlantis\_url\_events) | Webhook events URL of Atlantis |
| <a name="output_ecs_security_group"></a> [ecs\_security\_group](#output\_ecs\_security\_group) | Security group assigned to ECS Service in network configuration |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Task definition for ECS service (used for external triggers) |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of the VPC private subnets that were created or passed in |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of the VPC public subnets that were created or passed in |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The Atlantis ECS task role arn |
| <a name="output_task_role_id"></a> [task\_role\_id](#output\_task\_role\_id) | The Atlantis ECS task role id |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | The Atlantis ECS task role name |
| <a name="output_task_role_unique_id"></a> [task\_role\_unique\_id](#output\_task\_role\_unique\_id) | The stable and unique string identifying the Atlantis ECS task role. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC that was created or passed in |
| <a name="output_webhook_secret"></a> [webhook\_secret](#output\_webhook\_secret) | Webhook secret |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-atlantis/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/LICENSE) for full details.
