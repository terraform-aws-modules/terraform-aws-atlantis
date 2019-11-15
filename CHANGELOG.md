<a name="unreleased"></a>
## [Unreleased]



<a name="v2.4.0"></a>
## [v2.4.0] - 2019-11-15

- Govcloud ([#84](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/84))


<a name="v2.3.0"></a>
## [v2.3.0] - 2019-11-12

- Updated CHANGELOG
- Updated version of terraform-aws-acm module to v2.4.0 ([#81](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/81))


<a name="v2.2.0"></a>
## [v2.2.0] - 2019-07-21

- Updated CHANGELOG
- Update documentation a bit after merge
- Add capability to attach additional security groups to ALB ([#66](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/66))


<a name="v2.1.0"></a>
## [v2.1.0] - 2019-06-13

- Updated CHANGELOG
- Fixed task creation when ECS task definition has not been created before ([#62](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/62))


<a name="v2.0.0"></a>
## [v2.0.0] - 2019-06-12

- Updated CHANGELOG
- Upgraded module to support Terraform 0.12 ([#58](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/58))


<a name="v1.18.0"></a>
## [v1.18.0] - 2019-06-12

- Updated CHANGELOG
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
- Merge pull request [#38](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/38) from kilbergr/kilbergr_add-vpc-to-outputs
- add vpc_id to outputs


<a name="v1.11.0"></a>
## [v1.11.0] - 2019-02-07

- Merge pull request [#37](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/37) from terraform-aws-modules/pr/35
- Follow up for [#35](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/35) and [#36](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/36)
- adding custom secrets and environment variables


<a name="v1.10.0"></a>
## [v1.10.0] - 2019-02-01

- Merge pull request [#32](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/32) from chenrui333/refresh-module-versions
- Update acm module version for DNS validation issue
- Update `cloudposse/ecs-container-definition/aws` to `v0.7.0`
- Merge branch 'master' into refresh-module-versions
- Refresh the underlying module to the latest release versions


<a name="v1.9.0"></a>
## [v1.9.0] - 2019-01-18

- Updated pre-commit
- Merge pull request [#30](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/30) from waeltken/http-to-https-redirect
- Adjust comments on ALB security groups
- Add http -> https redirect on the ALB


<a name="v1.8.0"></a>
## [v1.8.0] - 2019-01-07

- Merge pull request [#29](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/29) from waeltken/add-gitlab-hostname
- Add variable to configure gitlab hostname


<a name="v1.7.1"></a>
## [v1.7.1] - 2018-12-31

- Removed obsolete tasks json files


<a name="v1.7.0"></a>
## [v1.7.0] - 2018-12-31

- Merge pull request [#28](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/28) from terraform-aws-modules/refactor_container_definition
- Added secrets and refactored container definition section


<a name="v1.6.1"></a>
## [v1.6.1] - 2018-12-14

- Updated terraform.tfvars.sample


<a name="v1.6.0"></a>
## [v1.6.0] - 2018-12-14

- Merge pull request [#27](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/27) from terraform-aws-modules/gitlab-and-ssm
- Cleanup before merge
- Added support for gitlab and SSM parameter store
- Merge pull request [#26](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/26) from chenrui333/fix-readme
- Fix README


<a name="v1.5.1"></a>
## [v1.5.1] - 2018-09-28

- Fixed README after merge


<a name="v1.5.0"></a>
## [v1.5.0] - 2018-09-28

- Merge pull request [#20](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/20) from exosite/master
- Merge pull request [#21](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/21) from ldormoy/master
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
- Merge pull request [#18](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/18) from ldormoy/master
- Merge pull request [#1](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/1) from ldormoy/support-multiple-policies
- allow ECS task role to get multiple policiy attachments
- [#7](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/7) updates README with policy_arn input
- [#7](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/7) pass ECs task exec. policy as input variable


<a name="v1.3.0"></a>
## [v1.3.0] - 2018-08-19

- Merge pull request [#17](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/17) from bitflight-public/master
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

- Merge pull request [#12](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/12) from terraform-aws-modules/reuse_vps
- README fixes
- README fixes
- Allow reuse existing VPC and subnets
- Merge pull request [#11](https://github.com/terraform-aws-modules/terraform-aws-atlantis/issues/11) from terraform-aws-modules/github_webhook
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


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-atlantis/compare/v2.4.0...HEAD
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
