# AWS Terraform module which runs Atlantis on AWS Fargate

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub and GitLab.

This repository contains Terraform infrastructure code which creates AWS resources required to run [Atlantis](https://www.runatlantis.io/) on AWS, including:

- Virtual Private Cloud (VPC)
- SSL certificate using Amazon Certificate Manager (ACM)
- Application Load Balancer (ALB)
- Domain name using AWS Route53 which points to ALB
- [AWS Elastic Cloud Service (ECS)](https://aws.amazon.com/ecs/) and [AWS Fargate](https://aws.amazon.com/fargate/) running Atlantis Docker image

[AWS Fargate](https://aws.amazon.com/fargate/) is used instead of AWS ECS/EC2 to reduce the bill, and it is also a cool AWS service.

### Before using Atlantis and the code in this repository please make sure that you have read and understood the security implications described in [the official Atlantis documentation](https://github.com/runatlantis/atlantis#security).

## How to use this?

As often with the code published in [terraform-aws-modules GitHub organization](https://github.com/terraform-aws-modules) you should have everything to run this code and get Atlantis up and running.

There are two ways to do this:

1. [As a standalone project](https://github.com/terraform-aws-modules/terraform-aws-atlantis#run-atlantis-as-a-standalone-project)
2. [As a Terraform module](https://github.com/terraform-aws-modules/terraform-aws-atlantis#run-atlantis-as-a-terraform-module)

### Run Atlantis as a standalone project

1. Clone this github repository:

```
$ git clone git@github.com:terraform-aws-modules/terraform-aws-atlantis.git
$ cd terraform-aws-atlantis
```

2. Copy sample `terraform.tfvars.sample` into `terraform.tfvars` and specify required variables there.

3. Run `terraform init` to download required providers and modules.

4. Run `terraform apply` to apply the Terraform configuration and create required infrastructure.

5. Run `terraform output atlantis_route53_record_fqdn` to get URL where Atlantis is publicly reachable. (Note: It may take a minute or two to get it reachable for the first time)

Once this is done GitHub webhook has to be created to send events to your Atlantis endpoint. Read [Add GitHub Webhook](https://github.com/runatlantis/atlantis#add-github-webhook) in the official Atlantis documentation.

### Run Atlantis as a Terraform module

This way allows integration with your existing AWS resources (eg, existing VPC or Route53 resources)
 
```hcl
module "atlantis" {
  source = "terraform-aws-modules/atlantis/aws"

  name = "atlantis"

  # VPC
  cidr            = "10.20.0.0/20"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

  # DNS
  route53_zone_name = "terraform-aws-modules.modules.tf"

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  certificate_arn = "arn:aws:acm:eu-west-1:135367859851:certificate/70e008e1-c0e1-4c7e-9670-7bb5bd4f5a84"

  # Atlantis
  atlantis_github_user       = "atlantis-bot"
  atlantis_github_user_token = "examplegithubtoken"
}
```

## Notes

1. AWS Route53 zone is not created by this module, so zone specified as a value in `route53_zone_name` should be created before using this module. Check documentation for [aws_route53_zone](https://www.terraform.io/docs/providers/aws/r/route53_zone.html).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm_certificate_domain_name | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | string | `` | no |
| atlantis_github_user | GitHub username of the user that is running the Atlantis command | string | - | yes |
| atlantis_github_user_token | GitHub token of the user that is running the Atlantis command | string | - | yes |
| atlantis_image | Docker image to run Atlantis with. If not specified, official Atlantis image will be used | string | `` | no |
| atlantis_repo_whitelist | List of allowed repositories Atlantis can be used with | list | - | yes |
| atlantis_version | Verion of Atlantis to run. If not specified latest will be used | string | `latest` | no |
| azs | A list of availability zones in the region | list | - | yes |
| certificate_arn | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | string | `` | no |
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden | string | - | yes |
| cloudwatch_log_retention_in_days | Retention period of Atlantis CloudWatch logs | string | `7` | no |
| create_route53_record | Whether to create Route53 record for Atlantis | string | `true` | no |
| name | Name to use on all resources created (VPC, ALB, etc) | string | `atlantis` | no |
| private_subnets | A list of private subnets inside the VPC | list | - | yes |
| public_subnets | A list of public subnets inside the VPC | list | - | yes |
| route53_zone_name | Route53 zone name to create ACM certificate in and main A-record | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| atlantis_route53_record_fqdn | The CIDR block of the VPC |
| github_webhook_secret | Github webhook secret |
| vpc_id | The ID of the VPC |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is created and maintained by [Anton Babenko](https://github.com/antonbabenko).

[Seth Vargo](https://github.com/sethvargo) has created [atlantis-on-gke](https://github.com/sethvargo/atlantis-on-gke)(Terraform configurations for running Atlantis on [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine)). This inspired me to do similar stuff for AWS Fargate.

## License

Apache 2 Licensed. See LICENSE for full details.

