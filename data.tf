data "aws_security_groups" "alb" {
  count = length(var.security_group_names) >= 1 ? 1 : 0
  dynamic "filter" {
    for_each = var.security_group_names
    content {
      name   = "group-name"
      values = [filter.value]
    }
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}
