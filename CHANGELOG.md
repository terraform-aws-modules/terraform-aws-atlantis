# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



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


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.20.0...HEAD
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
