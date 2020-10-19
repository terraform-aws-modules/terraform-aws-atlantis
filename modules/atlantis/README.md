## Requirements

| Name | Version |
|------|---------|
| terraform | 0.13.4 |
| aws | >= 2.68, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acm\_certificate\_domain\_name | Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance. Specify if it is different from value in `route53_zone_name` | `string` | `""` | no |
| alb\_authenticate\_cognito | Map of AWS Cognito authentication parameters to protect ALB (eg, using SAML). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-cognito-action | `any` | `{}` | no |
| alb\_authenticate\_oidc | Map of Authenticate OIDC parameters to protect ALB (eg, using Auth0). See https://www.terraform.io/docs/providers/aws/r/lb_listener.html#authenticate-oidc-action | `any` | `{}` | no |
| alb\_http\_security\_group\_tags | Additional tags to put on the http security group | `map(string)` | `{}` | no |
| alb\_https\_security\_group\_tags | Additional tags to put on the https security group | `map(string)` | `{}` | no |
| alb\_ingress\_cidr\_blocks | List of IPv4 CIDR ranges to use on all ingress rules of the ALB. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| alb\_listener\_ssl\_policy\_default | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| alb\_log\_bucket\_name | S3 bucket (externally created) for storing load balancer access logs. Required if alb\_logging\_enabled is true. | `string` | `""` | no |
| alb\_log\_location\_prefix | S3 prefix within the log\_bucket\_name under which logs are stored. | `string` | `""` | no |
| alb\_logging\_enabled | Controls if the ALB will log requests to S3. | `bool` | `false` | no |
| allow\_unauthenticated\_access | Whether to create ALB listener rule to allow unauthenticated access for certain CIDR blocks (eg. allow GitHub webhooks to bypass OIDC authentication) | `bool` | `false` | no |
| allow\_unauthenticated\_access\_priority | ALB listener rule priority for allow unauthenticated access rule | `number` | `10` | no |
| atlantis\_fqdn | FQDN of Atlantis to use. Set this only to override Route53 and ALB's DNS name. | `string` | `null` | no |
| atlantis\_github\_app\_id | Id of a GitHub app that is running the Atlantis command | `string` | `""` | no |
| atlantis\_github\_app\_key\_file | Path to a GitHub App PEM encoded private key file | `string` | `""` | no |
| atlantis\_github\_organization | GitHub organization | `string` | `""` | no |
| atlantis\_github\_user | GitHub username that is running the Atlantis command | `string` | `""` | no |
| atlantis\_github\_user\_token\_ssm\_parameter\_name | Name of SSM parameter to keep Atlantis GitHub user token secret | `string` | `""` | no |
| atlantis\_github\_webhook\_secret\_ssm\_parameter\_name | Name of SSM parameter to keep Atlantis GitHub webhook secret | `string` | n/a | yes |
| atlantis\_hide\_prev\_plan\_comments | Enables atlantis server --hide-prev-plan-comments hiding previous plan comments on update | `string` | `"false"` | no |
| atlantis\_image | Docker image to run Atlantis with. If not specified, official Atlantis image will be used | `string` | `""` | no |
| atlantis\_log\_level | Log level that Atlantis will run with. Accepted values are: <debug\|info\|warn\|error> | `string` | `"debug"` | no |
| atlantis\_port | Local port Atlantis should be running on. Default value is most likely fine. | `number` | `4141` | no |
| atlantis\_repo\_config\_json | Path to a JSON server-side repo config file | `string` | `""` | no |
| atlantis\_repo\_whitelist | List of allowed repositories Atlantis can be used with | `list(string)` | n/a | yes |
| atlantis\_security\_group\_tags | Additional tags to put on the atlantis security group | `map(string)` | `{}` | no |
| atlantis\_version | Verion of Atlantis to run. If not specified latest will be used | `string` | `"latest"` | no |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| certificate\_arn | ARN of certificate issued by AWS ACM. If empty, a new ACM certificate will be created and validated using Route53 DNS | `string` | `""` | no |
| cidr | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| cloudwatch\_log\_retention\_in\_days | Retention period of Atlantis CloudWatch logs | `number` | `7` | no |
| command | The command that is passed to the container | `list(string)` | `null` | no |
| container\_depends\_on | The dependencies defined for container startup and shutdown. A container can contain multiple dependencies. When a dependency is defined for container startup, for container shutdown it is reversed. The condition can be one of START, COMPLETE, SUCCESS or HEALTHY | <pre>list(object({<br>    containerName = string<br>    condition     = string<br>  }))</pre> | `null` | no |
| container\_memory\_reservation | The amount of memory (in MiB) to reserve for the container | `number` | `128` | no |
| create\_route53\_record | Whether to create Route53 record for Atlantis | `bool` | `true` | no |
| custom\_container\_definitions | A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used. | `string` | `""` | no |
| custom\_environment\_secrets | List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`) | <pre>list(object(<br>    {<br>      name      = string<br>      valueFrom = string<br>    }<br>  ))</pre> | `[]` | no |
| custom\_environment\_variables | List of additional environment variables the container will use (list should contain maps with `name` and `value`) | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>    }<br>  ))</pre> | `[]` | no |
| default\_terraform\_version | Terraform version to default to | `string` | `"v0.13.4"` | no |
| docker\_labels | The configuration options to send to the `docker_labels` | `map(string)` | `null` | no |
| ecs\_container\_insights | Controls if ECS Cluster has container insights enabled | `bool` | `false` | no |
| ecs\_service\_assign\_public\_ip | Should be true, if ECS service is using public subnets (more info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_cannot_pull_image.html) | `bool` | `false` | no |
| ecs\_service\_deployment\_maximum\_percent | The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment | `number` | `200` | no |
| ecs\_service\_deployment\_minimum\_healthy\_percent | The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment | `number` | `50` | no |
| ecs\_service\_desired\_count | The number of instances of the task definition to place and keep running | `number` | `1` | no |
| ecs\_task\_cpu | The number of cpu units used by the task | `number` | `256` | no |
| ecs\_task\_memory | The amount (in MiB) of memory used by the task | `number` | `512` | no |
| entrypoint | The entry point that is passed to the container | `list(string)` | `null` | no |
| essential | Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value | `bool` | `true` | no |
| firelens\_configuration | The FireLens configuration for the container. This is used to specify and configure a log router for container logs. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html | <pre>object({<br>    type    = string<br>    options = map(string)<br>  })</pre> | `null` | no |
| github\_webhooks\_cidr\_blocks | List of CIDR blocks used by GitHub webhooks | `list(string)` | <pre>[<br>  "140.82.112.0/20",<br>  "185.199.108.0/22",<br>  "192.30.252.0/22"<br>]</pre> | no |
| internal | Whether the load balancer is internal or external | `bool` | `false` | no |
| mount\_points | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional. | `list` | `[]` | no |
| name | Name to use on all resources created (VPC, ALB, etc) | `string` | `"atlantis"` | no |
| policies\_arn | A list of the ARN of the policies you want to apply | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"<br>]</pre> | no |
| private\_subnet\_ids | A list of IDs of existing private subnets inside the VPC | `list(string)` | `[]` | no |
| private\_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnet\_ids | A list of IDs of existing public subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| readonly\_root\_filesystem | Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value | `bool` | `false` | no |
| repository\_credentials | Container repository credentials; required when using a private repo.  This map currently supports a single key; "credentialsParameter", which should be the ARN of a Secrets Manager's secret holding the credentials | `map(string)` | `null` | no |
| route53\_record\_name | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| route53\_zone\_name | Route53 zone name to create ACM certificate in and main A-record, without trailing dot | `string` | `""` | no |
| security\_group\_ids | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| ssm\_kms\_key\_arn | ARN of KMS key to use for encryption and decryption of SSM Parameters. Required only if your key uses a custom KMS key and not the default key | `string` | `""` | no |
| start\_timeout | Time duration (in seconds) to wait before giving up on resolving dependencies for a container | `number` | `30` | no |
| stop\_timeout | Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own | `number` | `30` | no |
| tags | A map of tags to use on all resources | `map(string)` | `{}` | no |
| ulimits | Container ulimit settings. This is a list of maps, where each map should contain "name", "hardLimit" and "softLimit" | <pre>list(object({<br>    name      = string<br>    hardLimit = number<br>    softLimit = number<br>  }))</pre> | `null` | no |
| user | The user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group. The default (null) will use the container's configured `USER` directive or root if not set. | `string` | `null` | no |
| volumes\_from | A list of VolumesFrom maps which contain "sourceContainer" (name of the container that has the volumes to mount) and "readOnly" (whether the container can write to the volume) | <pre>list(object({<br>    sourceContainer = string<br>    readOnly        = bool<br>  }))</pre> | `[]` | no |
| vpc\_id | ID of an existing VPC where resources will be created | `string` | `""` | no |
| whitelist\_unauthenticated\_cidr\_blocks | List of allowed CIDR blocks to bypass authentication | `list(string)` | `[]` | no |
| working\_directory | The working directory to run commands inside the container | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_dns\_name | Dns name of alb |
| alb\_zone\_id | Zone ID of alb |
| atlantis\_url | URL of Atlantis |
| atlantis\_url\_events | Webhook events URL of Atlantis |
| ecs\_security\_group | Security group assigned to ECS Service in network configuration |
| ecs\_task\_definition | Task definition for ECS service (used for external triggers) |
| private\_subnet\_ids | IDs of the VPC private subnets that were created or passed in |
| public\_subnet\_ids | IDs of the VPC public subnets that were created or passed in |
| task\_role\_arn | The Atlantis ECS task role arn |
| task\_role\_id | The Atlantis ECS task role id |
| task\_role\_name | The Atlantis ECS task role name |
| task\_role\_unique\_id | The stable and unique string identifying the Atlantis ECS task role. |
| vpc\_id | ID of the VPC that was created or passed in |

