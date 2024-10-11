# Atlantis on AWS Fargate Terraform Module

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub, GitLab and Bitbucket Cloud.

> Before using Atlantis and the code in this repository, please make sure that you have read and understood the security implications described in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html).

## Usage

GitHub is shown below in usage examples; however, any git provider supported by Atlantis can be used by simply using the correct Atlantis environment variables and configuring the respective webhook for the given git provider.

See the [Supplemental Docs](https://github.com/terraform-aws-modules/terraform-aws-atlantis/blob/master/docs/README.md) for additional details on integrating with git providers.

### GitHub Complete

The Atlantis module creates all resources required to run Atlantis on AWS Fargate.

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  name = "atlantis"

  # ECS Container Definition
  atlantis = {
    environment = [
      {
        name  = "ATLANTIS_GH_USER"
        value = "myuser"
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = "github.com/terraform-aws-modules/*"
      },
    ]
    secrets = [
      {
        name      = "ATLANTIS_GH_TOKEN"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i"
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F"
      },
    ]
  }

  # ECS Service
  service = {
    task_exec_secret_arns = [
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i",
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F",
    ]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }
  service_subnets = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]
  vpc_id          = "vpc-1234556abcdef"

  # ALB
  alb_subnets             = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  certificate_domain_name = "example.com"
  route53_zone_id         = "Z2ES7B9AZ6SHAE"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

### GitHub Separate

The Atlantis module creates most of resources required to run Atlantis on AWS Fargate, except for the ECS Cluster and ALB. This allows you to integrate Atlantis with your existing AWS infrastructure.

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  name = "atlantis"

  # Existing cluster
  create_cluster = false
  cluster_arn    = "arn:aws:ecs:eu-west-1:123456789012:cluster/default"

  # Existing ALB
  create_alb            = false
  alb_target_group_arn  = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
  alb_security_group_id = "sg-12345678"

  # ECS Container Definition
  atlantis = {
    environment = [
      {
        name  = "ATLANTIS_GH_USER"
        value = "myuser"
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = "github.com/terraform-aws-modules/*"
      },
    ]
    secrets = [
      {
        name      = "ATLANTIS_GH_TOKEN"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i"
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom = "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F"
      },
    ]
  }

  # ECS Service
  service = {
    task_exec_secret_arns = [
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes256-7g8H9i",
      "arn:aws:secretsmanager:eu-west-1:111122223333:secret:aes192-4D5e6F",
    ]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }
  service_subnets = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]
  vpc_id          = "vpc-1234556abcdef"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

### Utilize EFS for Persistent Storage

You can enable EFS to ensure that any plan outputs are persisted to EFS in the event that the Atlantis Task is replaced:

```hcl
```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  # Truncated for brevity ...

  # EFS
  enable_efs = true
  efs = {
    mount_targets = {
      "eu-west-1a" = {
        subnet_id = "subnet-xyzde987"
      }
      "eu-west-1b" = {
        subnet_id = "subnet-slkjf456"
      }
      "eu-west-1c" = {
        subnet_id = "subnet-qeiru789"
      }
    }
  }
}
```

### Supply Atlantis server configuration

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

  atlantis = {
    environment = [
      {
        name : "ATLANTIS_REPO_CONFIG_JSON",
        value : jsonencode(yamldecode(file("${path.module}/server-atlantis.yaml"))),
      },
    ]
  }
}
```

## Examples

- [Complete Atlantis with GitHub webhook](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-complete)
- [Separate Atlantis with GitHub webhook](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/examples/github-separate)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 5.0.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 9.1.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws//modules/cluster | 5.11.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | 5.11.0 |
| <a name="module_efs"></a> [efs](#module\_efs) | terraform-aws-modules/efs/aws | 1.3.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | Map of values passed to ALB module definition. See the [ALB module](https://github.com/terraform-aws-modules/terraform-aws-alb) for full list of arguments supported | `any` | `{}` | no |
| <a name="input_alb_https_default_action"></a> [alb\_https\_default\_action](#input\_alb\_https\_default\_action) | Default action for the ALB https listener | `any` | <pre>{<br/>  "forward": {<br/>    "target_group_key": "atlantis"<br/>  }<br/>}</pre> | no |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ID of an existing security group that will be used by ALB. Required if `create_alb` is `false` | `string` | `""` | no |
| <a name="input_alb_subnets"></a> [alb\_subnets](#input\_alb\_subnets) | List of subnets to place ALB in. Required if `create_alb` is `true` | `list(string)` | `[]` | no |
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | ARN of an existing ALB target group that will be used to route traffic to the Atlantis service. Required if `create_alb` is `false` | `string` | `""` | no |
| <a name="input_atlantis"></a> [atlantis](#input\_atlantis) | Map of values passed to Atlantis container definition. See the [ECS container definition module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/container-definition) for full list of arguments supported | `any` | `{}` | no |
| <a name="input_atlantis_gid"></a> [atlantis\_gid](#input\_atlantis\_gid) | GID of the atlantis user | `number` | `1000` | no |
| <a name="input_atlantis_uid"></a> [atlantis\_uid](#input\_atlantis\_uid) | UID of the atlantis user | `number` | `100` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | `string` | `""` | no |
| <a name="input_certificate_domain_name"></a> [certificate\_domain\_name](#input\_certificate\_domain\_name) | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | `string` | `""` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Map of values passed to ECS cluster module definition. See the [ECS cluster module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/cluster) for full list of arguments supported | `any` | `{}` | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of an existing ECS cluster where resources will be created. Required when `create_cluster` is `false` | `string` | `""` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Determines whether to create an ALB or not | `bool` | `true` | no |
| <a name="input_create_certificate"></a> [create\_certificate](#input\_create\_certificate) | Determines whether to create an ACM certificate or not. If `false`, `certificate_arn` must be provided | `bool` | `true` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether to create an ECS cluster or not | `bool` | `true` | no |
| <a name="input_create_route53_records"></a> [create\_route53\_records](#input\_create\_route53\_records) | Determines whether to create Route53 `A` and `AAAA` records for the loadbalancer | `bool` | `true` | no |
| <a name="input_efs"></a> [efs](#input\_efs) | Map of values passed to EFS module definition. See the [EFS module](https://github.com/terraform-aws-modules/terraform-aws-efs) for full list of arguments supported | `any` | `{}` | no |
| <a name="input_enable_efs"></a> [enable\_efs](#input\_enable\_efs) | Determines whether to create and utilize an EFS filesystem | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Common name to use on all resources created unless a more specific name is provided | `string` | `"atlantis"` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID to use for ACM certificate and Route53 records | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Map of values passed to ECS service module definition. See the [ECS service module](https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/master/modules/service) for full list of arguments supported | `any` | `{}` | no |
| <a name="input_service_subnets"></a> [service\_subnets](#input\_service\_subnets) | List of subnets to place ECS service within | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_validate_certificate"></a> [validate\_certificate](#input\_validate\_certificate) | Determines whether to validate ACM certificate using Route53 DNS. If `false`, certificate will be created but not validated | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the resources will be provisioned | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | ALB created and all of its associated outputs |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | ECS cluster created and all of its associated outputs |
| <a name="output_efs"></a> [efs](#output\_efs) | EFS created and all of its associated outputs |
| <a name="output_service"></a> [service](#output\_service) | ECS service created and all of its associated outputs |
| <a name="output_url"></a> [url](#output\_url) | URL of Atlantis |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-atlantis/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-atlantis/tree/master/LICENSE) for full details.

## Additional information for users from Russia and Belarus

- Russia has [illegally annexed Crimea in 2014](https://en.wikipedia.org/wiki/Annexation_of_Crimea_by_the_Russian_Federation) and [brought the war in Donbas](https://en.wikipedia.org/wiki/War_in_Donbas) followed by [full-scale invasion of Ukraine in 2022](https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine).
- Russia has brought sorrow and devastations to millions of Ukrainians, killed hundreds of innocent people, damaged thousands of buildings, and forced several million people to flee.
- [Putin khuylo!](https://en.wikipedia.org/wiki/Putin_khuylo!)
