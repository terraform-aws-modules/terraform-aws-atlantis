# AWS Terraform module which runs Atlantis on AWS Fargate

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub, GitLab and Bitbucket Cloud.

This repository contains Terraform infrastructure code which creates AWS resources required to run [Atlantis](https://www.runatlantis.io/) on AWS, including:

- Virtual Private Cloud (VPC)
- SSL certificate using Amazon Certificate Manager (ACM)
- Application Load Balancer (ALB)
- Domain name using AWS Route53 which points to ALB
- [AWS Elastic Cloud Service (ECS)](https://aws.amazon.com/ecs/) and [AWS Fargate](https://aws.amazon.com/fargate/) running Atlantis Docker image
- AWS Parameter Store to keep secrets and access them in ECS task natively

[AWS Fargate](https://aws.amazon.com/fargate/) is used instead of AWS ECS/EC2 to reduce the bill, and it is also a cool AWS service.

Depending on which SCM system you use, Github repositories or Gitlab projects has to be configured to post events to Atlantis webhook URL.

See `README.md` in `examples` for Github or Gitlab for complete details.

## Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. Submit pull-requests to `master` branch.

Terraform 0.11. Pin module version to `~> v1.0`. Submit pull-requests to `terraform011` branch.

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
  atlantis_repo_whitelist    = ["github.com/terraform-aws-modules/*"]
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

## Notes

1. AWS Route53 zone is not created by this module, so zone specified as a value in `route53_zone_name` should be created before using this module. Check documentation for [aws_route53_zone](https://www.terraform.io/docs/providers/aws/r/route53_zone.html).
1. Currently this module configures Atlantis in a way that it can not be used to work with GitHub and Gitlab simultaneously (can't make list of ECS secrets conditionally).
1. For Bitbucket Cloud webhook configuration follow instructions in [the official Atlantis documentation](https://www.runatlantis.io/docs/configuring-webhooks.html#bitbucket-cloud-bitbucket-org-webhook).

<!-- TODO: For Bitbucket Cloud an IP whitelist should be implemented for the webhook url as stated in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html#bitbucket-cloud-bitbucket-org) due to lack of support for webhook secrets. -->

## Examples

* [GitHub repository webhook for Atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-repository-webhook)
* [GitLab repository webhook for Atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/gitlab-repository-webhook)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acm\_certificate\_domain\_name | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | `string` | `""` | no |
| alb\_ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules of the ALB. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| alb\_log\_bucket\_name | S3 bucket (externally created) for storing load balancer access logs. Required if alb\_logging\_enabled is true. | `string` | `""` | no |
| alb\_log\_location\_prefix | S3 prefix within the log\_bucket\_name under which logs are stored. | `string` | `""` | no |
| alb\_logging\_enabled | Controls if the ALB will log requests to S3. | `bool` | `false` | no |
| allow\_repo\_config | When true allows the use of atlantis.yaml config files within the source repos. | `string` | `"false"` | no |
| atlantis\_allowed\_repo\_names | Github repositories where webhook should be created | `list(string)` | `[]` | no |
| atlantis\_bitbucket\_base\_url | Base URL of Bitbucket Server, use for Bitbucket on prem (Stash) | `string` | `""` | no |
| atlantis\_bitbucket\_user | Bitbucket username that is running the Atlantis command | `string` | `""` | no |
| atlantis\_bitbucket\_user\_token | Bitbucket token of the user that is running the Atlantis command | `string` | `""` | no |
| atlantis\_bitbucket\_user\_token\_ssm\_parameter\_name | Name of SSM parameter to keep atlantis\_bitbucket\_user\_token | `string` | `"/atlantis/bitbucket/user/token"` | no |
| atlantis\_github\_user | GitHub username that is running the Atlantis command | `string` | `""` | no |
| atlantis\_github\_user\_token | GitHub token of the user that is running the Atlantis command | `string` | `""` | no |
| atlantis\_github\_user\_token\_ssm\_parameter\_name | Name of SSM parameter to keep atlantis\_github\_user\_token | `string` | `"/atlantis/github/user/token"` | no |
| atlantis\_gitlab\_hostname | Gitlab server hostname, defaults to gitlab.com | `string` | `"gitlab.com"` | no |
| atlantis\_gitlab\_user | Gitlab username that is running the Atlantis command | `string` | `""` | no |
| atlantis\_gitlab\_user\_token | Gitlab token of the user that is running the Atlantis command | `string` | `""` | no |
| atlantis\_gitlab\_user\_token\_ssm\_parameter\_name | Name of SSM parameter to keep atlantis\_gitlab\_user\_token | `string` | `"/atlantis/gitlab/user/token"` | no |
| atlantis\_image | Docker image to run Atlantis with. If not specified, official Atlantis image will be used | `string` | `""` | no |
| atlantis\_port | Local port Atlantis should be running on. Default value is most likely fine. | `number` | `4141` | no |
| atlantis\_repo\_whitelist | List of allowed repositories Atlantis can be used with | `list(string)` | n/a | yes |
| atlantis\_version | Verion of Atlantis to run. If not specified latest will be used | `string` | `"latest"` | no |
| aws\_ssm\_path | AWS ARN prefix for SSM (public AWS region or Govcloud). Valid options: aws, aws-us-gov. | `string` | `"aws"` | no |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| certificate\_arn | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | `string` | `""` | no |
| cidr | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| cloudwatch\_log\_retention\_in\_days | Retention period of Atlantis CloudWatch logs | `number` | `7` | no |
| container\_memory\_reservation | The amount of memory (in MiB) to reserve for the container | `number` | `128` | no |
| create\_route53\_record | Whether to create Route53 record for Atlantis | `bool` | `true` | no |
| custom\_container\_definitions | A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used. | `string` | `""` | no |
| custom\_environment\_secrets | List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`) | `list(map(string))` | `[]` | no |
| custom\_environment\_variables | List of additional environment variables the container will use (list should contain maps with `name` and `value`) | `list(map(string))` | `[]` | no |
| ecs\_service\_assign\_public\_ip | Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html) | `bool` | `false` | no |
| ecs\_service\_deployment\_maximum\_percent | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| ecs\_service\_deployment\_minimum\_healthy\_percent | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `50` | no |
| ecs\_service\_desired\_count | The number of instances of the task definition to place and keep running | `number` | `1` | no |
| ecs\_task\_cpu | The number of cpu units used by the task | `number` | `256` | no |
| ecs\_task\_memory | The amount (in MiB) of memory used by the task | `number` | `512` | no |
| name | Name to use on all resources created (VPC, ALB, etc) | `string` | `"atlantis"` | no |
| policies\_arn | A list of the ARN of the policies you want to apply | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"<br>]</pre> | no |
| private\_subnet\_ids | A list of IDs of existing private subnets inside the VPC | `list(string)` | `[]` | no |
| private\_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnet\_ids | A list of IDs of existing public subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| route53\_zone\_name | Route53 zone name to create ACM certificate in and main A-record, without trailing dot | `string` | `""` | no |
| security\_group\_ids | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| ssm\_kms\_key\_arn | ARN of KMS key to use for entryption and decryption of SSM Parameters. Required only if your key uses a custom KMS key and not the default key | `string` | `""` | no |
| tags | A map of tags to use on all resources | `map(string)` | `{}` | no |
| vpc\_id | ID of an existing VPC where resources will be created | `string` | `""` | no |
| webhook\_ssm\_parameter\_name | Name of SSM parameter to keep webhook secret | `string` | `"/atlantis/webhook/secret"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_dns\_name | Dns name of alb |
| atlantis\_allowed\_repo\_names | Github repositories where webhook should be created |
| atlantis\_url | URL of Atlantis |
| atlantis\_url\_events | Webhook events URL of Atlantis |
| ecs\_task\_definition | Task definition for ECS service (used for external triggers) |
| task\_role\_arn | The Atlantis ECS task role arn |
| vpc\_id | ID of the VPC that was created or passed in |
| webhook\_secret | Webhook secret |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is created and maintained by [Anton Babenko](https://github.com/antonbabenko).

[Seth Vargo](https://github.com/sethvargo) has created [atlantis-on-gke](https://github.com/sethvargo/atlantis-on-gke)(Terraform configurations for running Atlantis on [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine)). This inspired me to do similar stuff for AWS Fargate.

## License

Apache 2 Licensed. See LICENSE for full details.

