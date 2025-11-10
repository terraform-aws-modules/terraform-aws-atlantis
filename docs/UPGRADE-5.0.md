# Upgrade from v4.x to v5.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported version of Terraform AWS provider updated to `v6.19` to support the latest resources utilized
- Minimum supported version of Terraform updated to `v1.10` (min supported version for ACM module used within this module)
- The underlying `aws_security_group_rule` have been replaced with `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` to allow for more flexibility in defining security group rules.
- The attributes used to construct the container definition(s) have been changed from HCL's norm of `snake_case` to `camelCase` to match the AWS API. There currently isn't a [resource nor data source for the container definition](https://github.com/hashicorp/terraform-provider-aws/issues/17988), so one is constructed entirely from HCL in the `container-definition` sub-module. This definition is then rendered as JSON when presented to the task definition (or task set) APIs. Previously, the variable names used were `snake_case` and then internally converted to `camelCase`. However, this does not allow for [using the `container-definition` sub-module on its own](https://github.com/terraform-aws-modules/terraform-aws-ecs/issues/147) due to the mismatch between casing. Its probably going to trip a few folks up, but hopefully we'll remove this for a data source in the future.
- `service.task_exec_ssm_param_arns` default of `["arn:aws:ssm:*:*:parameter/*"]` has been removed to prevent unintended permission grants. If you were relying on this default, you will need to explicitly set this variable in your configuration.
- `service.task_exec_secret_arns` default of `["arn:aws:secretsmanager:*:*:secret:*"]` has been removed to prevent unintended permission grants. If you were relying on this default, you will need to explicitly set this variable in your configuration.

## Additional changes

### Added

- Support for `region` argument to specify the AWS region for the resources created if different from the provider region.

### Modified

- The ALB module used within this module has been updated to `v10.2.0`
- The ECS cluster and service modules used within this module have been updated to `v6.7.0`
- The ACM module used within this module has been updated to `v6.1.1`
- The EFS module used within this module has been updated to `v2.0.0`
- Variable definitions now contain detailed object types in place of the previously used `any` type

### Removed

- None

### Variable and output changes

1. Removed variables:

    - `atlantis_gid` -> is now `atlantis.group_id` within the `atlantis` object variable
    - `atlantis_uid` -> is now `atlantis.user_id` within the `atlantis` object variable
    - `alb_https_default_action` -> replaced by `alb.https_default_action` within the `alb` object variable
    - `alb_subnets` -> replaced by `alb.subnet_ids` within the `alb` object variable
    - `service_subnets` -> replaced by `service.subnet_ids` within the `service` object variable
    - From the `alb` object variable:
      - `customer_owned_ipv4_pool`
      - `desync_mitigation_mode`
      - `dns_record_client_routing_policy`
      - `enable_tls_version_and_cipher_suite_headers`
      - `enable_xff_client_port`
      - `load_balancer_type`
      - `xff_header_processing_mode`
    - From the `service` object variable:
      - `ignore_task_definition_changes`
      - `alarms`
      - `deployment_controller`
      - `deployment_maximum_percent` - Atlantis only supports 1 running instance
      - `deployment_minimum_healthy_percent` - Atlantis only supports 1 running instance
      - `desired_count` - Atlantis only supports 1 running instance
      - `enable_execute_command`
      - `ordered_placement_strategy`
      - `placement_constraints`
      - `scheduling_strategy`
      - `service_connect_configuration`
      - `service_registries`
      - `container_definition_defaults`
      - `inference_accelerator`
      - `ipc_mode`
      - `pid_mode`
      - `task_definition_placement_constraints`
      - `proxy_configuration`
      - `skip_destroy`
      - `external_id`
      - `scale`
      - `force_delete`
      - `wait_until_stable`
      - `wait_until_stable_timeout`
      - `enable_autoscaling`
      - `autoscaling_min_capacity`
      - `autoscaling_max_capacity`
      - `autoscaling_policies`
      - `autoscaling_scheduled_actions`
    - From the `atlantis` object variable:
      - `essential` - now always true
      - `extra_hosts`
      - `interactive`
      - `links`
      - `pseudo_terminal`
      - `system_controls`
    - From the `efs` object variable:
      - `create_backup_policy`
      - `enable_backup_policy`
      - `create_replication_configuration`
      - `replication_configuration_destination`

2. Renamed variables:

    - `cluster.settings` -> `cluster.setting` (singular)
    - `cluster.fargate_capacity_providers` -> replaced by `cluster.default_capacity_provider_strategy`

3. Added variables:

    - `region`

4. Removed outputs:

    - None

5. Renamed outputs:

    - None

6. Added outputs:

    - None

## Upgrade Migrations

### Diff of Before vs After

```diff
 module "atlantis" {
   source  = "terraform-aws-modules/atlantis/aws"
-  version = "4.4.1"
+  version = "5.0.0"

# Truncated for brevity, only the relevant changes shown

- alb_subnets     = module.vpc.public_subnets
alb = {
+    subnet_ids = module.vpc.public_subnets
  ...
}

- service_subnets = module.vpc.private_subnets
service = {
+    subnet_ids = module.vpc.private_subnets
  ...
}
```

### State Move Commands

None - the security group rules will be replaced on apply due to the change from `aws_security_group_rule` to `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule`
