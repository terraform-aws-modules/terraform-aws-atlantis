# AWS Terraform module which runs Atlantis on AWS Fargate

[Atlantis](https://www.runatlantis.io/) is tool which provides unified workflow for collaborating on Terraform through GitHub, GitLab and Bitbucket Cloud.

This repository contains Terraform infrastructure code which creates AWS resources required to run [Atlantis](https://www.runatlantis.io/) on AWS, including:

- SSL certificate using Amazon Certificate Manager (ACM)
- Application Load Balancer (ALB)
- Domain name using AWS Route53 which points to ALB
- [AWS Elastic Cloud Service (ECS)](https://aws.amazon.com/ecs/) and [AWS Fargate](https://aws.amazon.com/fargate/) running Atlantis Docker image

[AWS Fargate](https://aws.amazon.com/fargate/) is used instead of AWS ECS/EC2 to reduce the bill, and it is also a cool AWS service.

This code is in the `atlantis` [module](tree/master/modules/atlantis), and is based heavily on [terraform-aws-atlantis](https://github.com/terraform-aws-modules/terraform-aws-atlantis).

## Requirements/Configuration

1. You will need to have created either a GitHub app or a GitHub user, which Atlantis will use for communication with GitHub.

    1. If you choose to use a GitHub app, you should provide its app id as the `atlantis_github_app_id` input to the `atlantis` module. You will also need to provide a path to the app's private key file within the ECS container when it launches, as the `atlantis_github_app_key_file` input. To provide the private key file, we store the private key file as a Jenkins credential and build a new image containing the file as part of the deployment pipeline. We then provide the URI of that image as the `atlantis_image` input to the `atlantis` module.

    1. If you choose to use a GitHub user, you should provide its username as the `atlantis_github_user` input to the `atlantis` module. You should put its user token into AWS SSM/Parameter Store as a secret, and provide the ARN of that secret as the `atlantis_github_user_token_ssm_parameter_name` input.

1. You also need to create a GitHub webhook, to allow Atlantis to respond to pull event requests. You can follow the instructions [here](https://www.runatlantis.io/docs/configuring-webhooks.html#github-github-enterprise) to do so. Once this is set up, you will need to put the webhook secret into AWS SSM/Parameter Store as a secret, and provide the ARN of that secret as the `atlantis_github_webhook_secret_ssm_parameter_name` input to the `atlantis` module.

1. In order to run terraform commands, the ECS task will need permission to access:
    - your terraform state file 
    - your terraform-managed resources (so that it can inspect them)
If necessary, you should include IAM policies granting those permissions in the `policies_arn` list input to the `atlantis` module.

There are a number of additional infrastructure configuration options; see the `atlantis` module [README](blob/master/modules/atlantis/README.md) for details.


### Enabling Atlantis for a new repo

1. Add the repo to the `atlantis_repo_whitelist` list input to the `atlantis` module.
You can use wildcards here, eg. `"github.com/tophatmonocle/*"`. However, you probably want to only enable this for Terraform repos because Atlantis sometimes leaves comments on PRs that don't touch Terraform, including in repos that don't use Terraform at all (this is a [known issue](https://github.com/runatlantis/atlantis/issues/221), unfortunately).

1. Optionally, add the repo to the [server-side config file](blob/master/server-side-repo-config/repos.json), if you have one. This will allow you to define custom apply requirements and/or Atlantis workflows for the repo. Check the [Atlantis docs](https://www.runatlantis.io/docs/server-side-repo-config.html) for more description of the configuration options.

1. Optionally, create an Atlantis config file in the repo itself. This will allow you to select the terraform workspace against which terraform plan should run, eg. [`sandbox`](https://github.com/tophatmonocle/terraform-service/blob/d8844bea62feb6f72ff0414b5a312d8864f9e582/atlantis.yaml#L4). It also supports other configuration options; check the [Atlantis docs](https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html) for more details.
