# Changelog

All notable changes to this project will be documented in this file.

## [3.28.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.27.0...v3.28.0) (2023-05-12)


### Features

* Make the enable_nat_gateway and single_nat_gateway variables configurable ([#343](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/343)) ([375a926](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/375a926af8c5c9020e21861b45eb5cb9380cf776))

## [3.27.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.26.1...v3.27.0) (2023-05-12)


### Features

* Add EFS performance settings. ([#339](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/339)) ([ba3ecf9](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/ba3ecf96bcef5c32653219f06a3c373af1aca6bf))

### [3.26.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.26.0...v3.26.1) (2023-05-12)


### Bug Fixes

* Gitlab versioning errors with terraform 0.13 ([#344](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/344)) ([359ab38](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/359ab388ec9e34261268bd927e4013f8a7a230ea))

## [3.26.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.25.0...v3.26.0) (2022-12-15)


### Features

* Add ability to enable cross-zone load balancing ([#326](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/326)) ([1d1c75f](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/1d1c75f3396550920e4f55f2c2e10b99d39eecbb))

## [3.25.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.24.1...v3.25.0) (2022-11-16)


### Features

* Use base security-group module to remove duplicate EFS security group ([#325](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/325)) ([8433f55](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/8433f5562daba6a1bcf28a57982564827f7bfed8))

### [3.24.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.24.0...v3.24.1) (2022-11-07)


### Bug Fixes

* Update CI configuration files to use latest version ([#323](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/323)) ([cf975dd](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/cf975dd765b739ac9f3965ca81416c37f1f85c35))

## [3.24.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.23.1...v3.24.0) (2022-11-03)


### Features

* Add permissions to access repository credentials to `ecs_task_access_secrets` ([#306](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/306)) ([15e9d9b](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/15e9d9be786c74e7fda7aa621292500fc2e0dea4))

### [3.23.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.23.0...v3.23.1) (2022-11-01)


### Bug Fixes

* Remove unneeded ingress for EFS traffic from the entire VPC ([#318](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/318)) ([9e0c0ff](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/9e0c0ff1d3601d8e536b2d672cba4d1379286908))

## [3.23.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.22.1...v3.23.0) (2022-10-31)


### Features

* Added support for GitHub app ([#276](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/276)) ([27def83](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/27def8345252cbd17904f3a31188ed4f12aa7a88))

### [3.22.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.22.0...v3.22.1) (2022-10-22)


### Bug Fixes

* Cannot specify more than one extra_container_definitions ([#314](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/314)) ([7c1ad25](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/7c1ad25b53fb47db1c70086d2154a9532d320cd4))

## [3.22.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.21.0...v3.22.0) (2022-10-13)


### Features

* Add path option to IAM roles created under this module ([#311](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/311)) ([fe833a0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/fe833a0420e517ba2b63390c2063a49b6859ee62))

## [3.21.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.20.0...v3.21.0) (2022-09-22)


### Features

* Enable encrypt function on EFS ([#296](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/296)) ([792a685](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/792a685d8feea43e38d081d316c0b1915d656001))

## [3.20.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.19.0...v3.20.0) (2022-09-21)


### Features

* Add arguments in EFS file system ([#294](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/294)) ([089eb6c](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/089eb6c1e8dfeef45f4e9891714d86cb0783ac6b))

## [3.19.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.18.0...v3.19.0) (2022-09-07)


### Features

* Add output with public IP for whitelisting ([#309](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/309)) ([eb50e48](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/eb50e48854339969f480432d987ce4e1b3b69bee))

## [3.18.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.17.1...v3.18.0) (2022-07-14)


### Features

* Add `task_execution_session_duration` for task execution role ([#300](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/300)) ([16162ff](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/16162ff6b679f6d084aae81d016756c7165ff461))

### [3.17.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.17.0...v3.17.1) (2022-06-22)


### Bug Fixes

* set correct default for runtime_platform variable to ensure idempotence ([#291](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/291)) ([96c8613](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/96c861355985b81226c0119afab46fc8eb44ec30))

## [3.17.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.16.0...v3.17.0) (2022-06-15)


### Features

* Ensure EFS is owned by the posix_user to avoid permission issues ([#287](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/287)) ([61cdf8f](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/61cdf8fd3dec550c47f3b817ea301927e2f18473))

## [3.16.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.15.1...v3.16.0) (2022-05-15)


### Features

* Add support for runtime_platform config block ([#279](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/279)) ([4b93dee](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/4b93deee7032072811e9d5f8192154a58c40fb82))

### [3.15.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.15.0...v3.15.1) (2022-05-09)


### Bug Fixes

* Fix the GitHub complete example ([#277](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/277)) ([47bd5d4](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/47bd5d476cba1bcf716923bfdb110ae81555783c))

## [3.15.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.14.0...v3.15.0) (2022-04-26)


### Features

* Introduce IPv6 CIDR specific allow ALBs variables ([#275](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/275)) ([bc5ad7c](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/bc5ad7c88b631a9d00e1a88bfb9b45873cbce017))

## [3.14.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.13.1...v3.14.0) (2022-04-01)


### Features

* Add IPv6 support (ALB and Route53 AAAA record) ([#256](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/256)) ([6cefda0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/6cefda0c23ae3632a2198ca61b2fd7c4688c9c87))

### [3.13.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.13.0...v3.13.1) (2022-04-01)


### Bug Fixes

* Only create mount point for EFS when using EFS ([#261](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/261)) ([b1b61f3](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/b1b61f33081b17953a809645b7ed0a09f8c154c0))

## [3.13.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.12.0...v3.13.0) (2022-03-12)


### Features

* Made it clear that we stand with Ukraine ([e798c34](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/e798c34cb40e8e8041c55367b99a310c06a03d13))

## [3.12.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.11.0...v3.12.0) (2022-02-11)


### Features

* Allow for an existing ECS cluster to be used ([#233](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/233)) ([6b7594a](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/6b7594ae487472d4947518571209c2e380341d45))

## [3.11.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.10.0...v3.11.0) (2022-02-10)


### Features

* Added a possibility to allow private hosted zone usage ([#250](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/250)) ([5a53f39](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/5a53f39f0dc4942a2044451ef63752b7b9c807ab))

## [3.10.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.9.0...v3.10.0) (2022-02-10)


### Features

* Added support for persisting Atlantis state using EFS ([#247](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/247)) ([79d152e](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/79d152eeaea5fdf512c4d6ef3cb11143e38e0803))

## [3.9.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.8.0...v3.9.0) (2022-02-08)


### Features

* Remove not used parameter `atlantis_allowed_repo_names` ([#221](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/221)) ([6cbd47d](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/6cbd47dfe45fb45c0b5d99b238a7837a51e667f5))

## [3.8.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.7.0...v3.8.0) (2022-01-19)


### Features

* Allow CloudWatch Log Encryption and Default Security Group Management ([#246](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/246)) ([6a27fff](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/6a27fffbd64fc92e49ee6449b937498a9dc35856))

## [3.7.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.6.0...v3.7.0) (2022-01-17)


### Features

* Add base URL for GitHub Enterprise ([#244](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/244)) ([4195ea2](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/4195ea27c69db0b1863be5cc479eea7bd9051dfe))

## [3.6.0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.5.3...v3.6.0) (2022-01-07)


### Features

* Allow more than 5 CIDRs in whitelist_unauthenticated_cidr_blocks ([#220](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/220)) ([df10f7b](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/df10f7bc3d703dacdca3de2dc2b773c730d72898))

## [3.5.3](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.5.2...v3.5.3) (2021-12-06)


### Bug Fixes

* atlantis health check path ([#242](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/242)) ([0b17a41](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/0b17a4102f5f21e7a6de72a3b9ed7760c4ca7c9a))
* ensure pre-commit is using latest version via HTTPS ([#240](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/240)) ([57935f0](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/57935f0530e4502ddc6da2621600d887488f4c76))

## [3.5.2](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.5.1...v3.5.2) (2021-11-19)


### Bug Fixes

* correct semantic-release message that is causing releases to fail ([#239](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/239)) ([ff0e47d](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/ff0e47d995e1f2b32b7dafeed78a8e706fc62857))

## [3.5.1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.5.0...v3.5.1) (2021-11-19)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#237](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/237)) ([75b3376](https://github.com/terraform-aws-modules/terraform-aws-atlantis/commit/75b33768f7943474070feef5687aa3e147af9814))

<a name="v3.5.0"></a>
## [v3.5.0] - 2021-11-14

- feat: Add ability to use Fargate Ephemeral Storage ([#229](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/229))
- docs: Added google oidc example to readme ([#234](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/234))


<a name="v3.4.0"></a>
## [v3.4.0] - 2021-11-01

- feat: Added ability to add extra loadbalancer blocks to ECS task ([#232](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/232))


<a name="v3.3.0"></a>
## [v3.3.0] - 2021-09-24

- feat: Allow unauthenticated access for webhooks to /events endpoint if needed ([#226](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/226))
- fix: Add missing netblock (143.55.64.0/20) to GitHub webhook IP ranges ([#225](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/225))


<a name="v3.2.0"></a>
## [v3.2.0] - 2021-09-16

- feat: Add sensitive flag for webhook secret outputs ([#222](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/222))


<a name="v3.1.0"></a>
## [v3.1.0] - 2021-09-01

- feat: update default image to ghcr.io one ([#219](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/219))


<a name="v3.0.0"></a>
## [v3.0.0] - 2021-08-31

- BREAKING CHANGE: update internal modules to latest, replace `github_organization` with `github_owner`, bump Terraform version to >=0.13.1 ([#218](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/218))


<a name="v2.43.0"></a>
## [v2.43.0] - 2021-08-17

- feat: Added outputs of ECS and ALB resources ([#216](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/216))


<a name="v2.42.0"></a>
## [v2.42.0] - 2021-06-29

- feat: Add support for AWS ECS Exec ([#209](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/209))


<a name="v2.41.0"></a>
## [v2.41.0] - 2021-05-17

- feat: Only tag ecs service if longer arns are enabled in the aws account ([#153](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/153))
- docs: Example of providing server yaml configuration ([#205](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/205))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#203](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/203))


<a name="v2.40.0"></a>
## [v2.40.0] - 2021-04-15

- feat: Renamed option to repo_allowlist ([#198](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/198))


<a name="v2.39.0"></a>
## [v2.39.0] - 2021-04-13

- feat: Add `force_new_deployment` switch ([#196](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/196))


<a name="v2.38.0"></a>
## [v2.38.0] - 2021-04-13

- feat: Add enable deletion protection and drop invalid header fields ([#195](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/195))


<a name="v2.37.0"></a>
## [v2.37.0] - 2021-04-07

- feat: allow adding more trusted principals to task role ([#193](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/193))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#191](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/191))


<a name="v2.36.0"></a>
## [v2.36.0] - 2021-03-16

- fix: Optionally lookup for the latest task definition ([#163](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/163))
- chore: Add okta oidc details in README ([#188](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/188))


<a name="v2.35.0"></a>
## [v2.35.0] - 2021-03-02

- fix: revert module Terraform 0.13.x version upgrade ([#186](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/186))


<a name="v2.34.0"></a>
## [v2.34.0] - 2021-03-01

- fix: Update syntax for Terraform 0.15 ([#184](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/184))


<a name="v2.33.0"></a>
## [v2.33.0] - 2021-03-01

- feat: allow setting container memory & cpu from task memory & cpu ([#169](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/169))
- chore: correct versions used and required versions ([#183](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/183))
- chore: add ci-cd workflow for pre-commit checks ([#182](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/182))


<a name="v2.32.0"></a>
## [v2.32.0] - 2021-02-20

- chore: update documentation based on latest `terraform-docs` which includes module and resource sections ([#180](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/180))


<a name="v2.31.0"></a>
## [v2.31.0] - 2021-02-08

- feat: Add enable_ecs_managed_tags and propagate_tags arguments to ecs_service ([#177](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/177))


<a name="v2.30.0"></a>
## [v2.30.0] - 2020-12-29

- feat: Add permissions boundary to ecs task iam role ([#176](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/176))


<a name="v2.29.0"></a>
## [v2.29.0] - 2020-12-24

- feat: support custom platform version ([#170](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/170))


<a name="v2.28.0"></a>
## [v2.28.0] - 2020-12-20

- fix: Update module dependencies for TF 0.14 support ([#172](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/172))


<a name="v2.27.0"></a>
## [v2.27.0] - 2020-12-10

- feat: allow adding more trusted principals to task role ([#155](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/155))


<a name="v2.26.0"></a>
## [v2.26.0] - 2020-11-13

- feat: allow for extra_container_definitions ([#162](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/162))


<a name="v2.25.0"></a>
## [v2.25.0] - 2020-11-10

- feat: Added support for Fargate Spot ([#164](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/164))


<a name="v2.24.0"></a>
## [v2.24.0] - 2020-09-01

- feat: Use atlantis bot instead of a github user ([#151](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/151))


<a name="v2.23.0"></a>
## [v2.23.0] - 2020-08-18

- feat: add variable to set SSL listener policy ([#150](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/150))


<a name="v2.22.0"></a>
## [v2.22.0] - 2020-08-17

- feat: Additional tags to security groups ([#142](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/142))


<a name="v2.21.0"></a>
## [v2.21.0] - 2020-08-17

- feat: update container definition including additional parameters to configure ([#148](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/148))


<a name="v2.20.0"></a>
## [v2.20.0] - 2020-06-29

- feat: Allow hide-prev-plan-comments  ([#138](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/138))


<a name="v2.19.0"></a>
## [v2.19.0] - 2020-06-23

- feat: Add tags to aws_ecs_service resource ([#136](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/136))


<a name="v2.18.0"></a>
## [v2.18.0] - 2020-06-20

- feat: Refactor to use SSM ARNs directly from resources ([#135](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/135))
- fix: cognito variables expect "user_pool_client_id" and "user_pool_domain" ([#134](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/134))


<a name="v2.17.0"></a>
## [v2.17.0] - 2020-05-27

- feat: Support ALB authentication using AWS Cognito ([#102](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/102))


<a name="v2.16.0"></a>
## [v2.16.0] - 2020-05-13

- feat: Added support for unauthenticated access (eg, Github webhook) ([#123](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/123))


<a name="v2.15.0"></a>
## [v2.15.0] - 2020-05-13

- feat: Added ALB authentication feature with OpenID Connect (eg, Auth0) ([#122](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/122))


<a name="v2.14.0"></a>
## [v2.14.0] - 2020-05-12

- fix: Revert deleted tags from many resources since release 2.7.0 ([#121](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/121))


<a name="v2.13.0"></a>
## [v2.13.0] - 2020-05-12

- feat: Allow custom Route53 record name (including empty) ([#120](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/120))


<a name="v2.12.0"></a>
## [v2.12.0] - 2020-05-12

- feat: Added atlantis_fqdn to override route53 and ALB dns name (closes [#94](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/94))
- fix: Expose ECS service security group as ouptut (closes [#87](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/87))


<a name="v2.11.0"></a>
## [v2.11.0] - 2020-05-12

- feat: Allow setting of Atlantis log level ([#118](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/118))


<a name="v2.10.0"></a>
## [v2.10.0] - 2020-05-12

- feat: Updated versions of VPC, SG, ACM modules ([#117](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/117))


<a name="v2.9.0"></a>
## [v2.9.0] - 2020-05-12

- feat: Add support for internal load balancer, upgraded ALB module ([#99](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/99))


<a name="v2.8.0"></a>
## [v2.8.0] - 2020-05-11

- fix: Update deprecated ALB listener rule format ([#89](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/89))
- docs: Minor doc edits ([#100](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/100))


<a name="v2.7.0"></a>
## [v2.7.0] - 2020-05-11

- fix: Updated version of cloudposse/ecs-container-definition/aws to 0.23.0 (closed [#86](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/86))


<a name="v2.6.0"></a>
## [v2.6.0] - 2020-04-13

- docs: Fixed README after terraform-docs was updated
- feat: Added tags to cluster, task, ssm, role, and fmt ([#115](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/115))


<a name="v2.5.0"></a>
## [v2.5.0] - 2020-02-22

- Updated pre-commit-terraform with README
- feat: add support for bitbucket stash base url ([#79](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/79))


<a name="v2.4.0"></a>
## [v2.4.0] - 2019-11-15

- Govcloud ([#84](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/84))


<a name="v2.3.0"></a>
## [v2.3.0] - 2019-11-12

- Updated version of terraform-aws-acm module to v2.4.0 ([#81](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/81))


<a name="v2.2.0"></a>
## [v2.2.0] - 2019-07-21

- Update documentation a bit after merge
- Add capability to attach additional security groups to ALB ([#66](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/66))


<a name="v2.1.0"></a>
## [v2.1.0] - 2019-06-13

- Fixed task creation when ECS task definition has not been created before ([#62](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/62))


<a name="v2.0.0"></a>
## [v2.0.0] - 2019-06-12

- Upgraded module to support Terraform 0.12 ([#58](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/58))


<a name="v1.18.0"></a>
## [v1.18.0] - 2019-06-12

- Add Task Definition Output ([#53](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/53))


<a name="v1.17.0"></a>
## [v1.17.0] - 2019-04-26

- Add optional support for ALB logging ([#49](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/49))


<a name="v1.16.0"></a>
## [v1.16.0] - 2019-03-18

- Fix github user token env to ATLANTIS_GH_TOKEN ([#46](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/46))


<a name="v1.15.0"></a>
## [v1.15.0] - 2019-03-16

- Add support for Bitbucket Cloud ([#45](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/45))


<a name="v1.14.0"></a>
## [v1.14.0] - 2019-03-16

- add alb dns name to outputs ([#44](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/44))


<a name="v1.13.0"></a>
## [v1.13.0] - 2019-03-07

- workaround to not error on accessing value on data element that doesn't exist ([#42](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/42))
- replace /20 to /16 in README.md ([#40](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/40))


<a name="v1.12.0"></a>
## [v1.12.0] - 2019-02-14

- Fixed documentation after [#38](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/38)
- add vpc_id to outputs


<a name="v1.11.0"></a>
## [v1.11.0] - 2019-02-07

- Follow up for [#35](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/35) and [#36](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/36)
- adding custom secrets and environment variables


<a name="v1.10.0"></a>
## [v1.10.0] - 2019-02-01

- Update acm module version for DNS validation issue
- Update `cloudposse/ecs-container-definition/aws` to `v0.7.0`
- Merge branch 'master' into refresh-module-versions
- Refresh the underlying module to the latest release versions


<a name="v1.9.0"></a>
## [v1.9.0] - 2019-01-18

- Updated pre-commit
- Adjust comments on ALB security groups
- Add http -> https redirect on the ALB


<a name="v1.8.0"></a>
## [v1.8.0] - 2019-01-07

- Add variable to configure gitlab hostname


<a name="v1.7.1"></a>
## [v1.7.1] - 2018-12-31

- Removed obsolete tasks json files


<a name="v1.7.0"></a>
## [v1.7.0] - 2018-12-31

- Added secrets and refactored container definition section


<a name="v1.6.1"></a>
## [v1.6.1] - 2018-12-14

- Updated terraform.tfvars.sample


<a name="v1.6.0"></a>
## [v1.6.0] - 2018-12-14

- Cleanup before merge
- Added support for gitlab and SSM parameter store
- Fix README


<a name="v1.5.1"></a>
## [v1.5.1] - 2018-09-28

- Fixed README after merge


<a name="v1.5.0"></a>
## [v1.5.0] - 2018-09-28

- updates README
- fixes typo variable name
- allows custom value for alb ingress_cidr_blocks
- mention about trailing dot of route53_zone_name in inputs
- fix whitelist and zone_name example


<a name="v1.4.1"></a>
## [v1.4.1] - 2018-09-14

- Fixed example in README (thanks Giuseppe B.)


<a name="v1.4.0"></a>
## [v1.4.0] - 2018-09-07

- Fixes after [#18](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/18)
- allow ECS task role to get multiple policiy attachments
- [#7](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/7) updates README with policy_arn input
- [#7](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/7) pass ECs task exec. policy as input variable


<a name="v1.3.0"></a>
## [v1.3.0] - 2018-08-19

- Added a task role to the container
- setthe maximum count to 200, and the minimum to 50%, so that there is no atlantis outage when deploying
- added Task role output. Added the atlantis config in repo support
- added Task role output. Added the atlantis config in repo support
- Modified the atlantis definition to use a datasource that checks for the latest revision.
- Modified the atlantis definition to use a datasource that checks for the latest revision.
- Modified the atlantis definition to use a datasource that checks for the latest revision.
- Modified the task definition to use the provided container name


<a name="v1.2.0"></a>
## [v1.2.0] - 2018-06-03

- Upgraded version of security-group


<a name="v1.1.1"></a>
## [v1.1.1] - 2018-06-03

- Added deregistration_delay=10 to update ALB faster


<a name="v1.1.0"></a>
## [v1.1.0] - 2018-05-26

- README fixes
- README fixes
- Allow reuse existing VPC and subnets
- Format tfvars
- Added github-repository-webhook


<a name="v1.0.0"></a>
## v1.0.0 - 2018-05-25

- Updated readme
- Updated readme
- Updated readme
- Minor cleanup
- Initial commit
- Initial commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.5.0...HEAD
[v3.5.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.4.0...v3.5.0
[v3.4.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.3.0...v3.4.0
[v3.3.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.2.0...v3.3.0
[v3.2.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.1.0...v3.2.0
[v3.1.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v3.0.0...v3.1.0
[v3.0.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.43.0...v3.0.0
[v2.43.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.42.0...v2.43.0
[v2.42.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.41.0...v2.42.0
[v2.41.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.40.0...v2.41.0
[v2.40.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.39.0...v2.40.0
[v2.39.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.38.0...v2.39.0
[v2.38.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.37.0...v2.38.0
[v2.37.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.36.0...v2.37.0
[v2.36.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.35.0...v2.36.0
[v2.35.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.34.0...v2.35.0
[v2.34.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.33.0...v2.34.0
[v2.33.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.32.0...v2.33.0
[v2.32.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.31.0...v2.32.0
[v2.31.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.30.0...v2.31.0
[v2.30.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.29.0...v2.30.0
[v2.29.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.28.0...v2.29.0
[v2.28.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.27.0...v2.28.0
[v2.27.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.26.0...v2.27.0
[v2.26.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.25.0...v2.26.0
[v2.25.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.24.0...v2.25.0
[v2.24.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.23.0...v2.24.0
[v2.23.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.22.0...v2.23.0
[v2.22.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.21.0...v2.22.0
[v2.21.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.20.0...v2.21.0
[v2.20.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.19.0...v2.20.0
[v2.19.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.18.0...v2.19.0
[v2.18.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.17.0...v2.18.0
[v2.17.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.16.0...v2.17.0
[v2.16.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.15.0...v2.16.0
[v2.15.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.14.0...v2.15.0
[v2.14.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.13.0...v2.14.0
[v2.13.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.12.0...v2.13.0
[v2.12.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.11.0...v2.12.0
[v2.11.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.10.0...v2.11.0
[v2.10.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.9.0...v2.10.0
[v2.9.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.8.0...v2.9.0
[v2.8.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.7.0...v2.8.0
[v2.7.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.6.0...v2.7.0
[v2.6.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.5.0...v2.6.0
[v2.5.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.4.0...v2.5.0
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.18.0...v2.0.0
[v1.18.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.17.0...v1.18.0
[v1.17.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.16.0...v1.17.0
[v1.16.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.15.0...v1.16.0
[v1.15.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.14.0...v1.15.0
[v1.14.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.13.0...v1.14.0
[v1.13.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.12.0...v1.13.0
[v1.12.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.11.0...v1.12.0
[v1.11.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.10.0...v1.11.0
[v1.10.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.9.0...v1.10.0
[v1.9.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.7.1...v1.8.0
[v1.7.1]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.7.0...v1.7.1
[v1.7.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.6.1...v1.7.0
[v1.6.1]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.6.0...v1.6.1
[v1.6.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.5.1...v1.6.0
[v1.5.1]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.5.0...v1.5.1
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.4.1...v1.5.0
[v1.4.1]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.4.0...v1.4.1
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.1.1...v1.2.0
[v1.1.1]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.1.0...v1.1.1
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v1.0.0...v1.1.0
