# AWS Terraform module which runs Atlantis on AWS Fargate

The documentation for the original repository is located in the README of their official Github, which is located [here](https://github.com/terraform-aws-modules/terraform-aws-atlantis). This has been modified to include Terraform state management across AWS accounts specifically for 2W users.

## Terraform versions

Terraform 0.12 or newer. Pin module version to `~> v2.0`. Submit pull-requests to `master` branch.

Terraform 0.11. Pin module version to `~> v1.0`.

### Before using Atlantis and the code in this repository please make sure that you have read and understood the security implications described in [the official Atlantis documentation](https://www.runatlantis.io/docs/security.html).

## Usage

This module is currently deployed in the 2W Sandbox Administration account via our [atlantis repo](https://github.com/2ndWatch/2w-atlantis). Please go there for detailed README instructions.

The original module is created and maintained by [Anton Babenko](https://github.com/antonbabenko). The 2nd Watch forked module is maintained by 2nd Watch.

## License

Apache 2 Licensed. See LICENSE for full details.
