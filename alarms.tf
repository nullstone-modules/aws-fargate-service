locals {
  metric_alarms = lookup(local.capabilities, "metric_alarms", [])

  tg_metric_alarms = [for ma in local.metric_alarms : ma if ma.type == "target-group"]
  all_tg_metric_alarms = merge([
    for ma in local.tg_metric_alarms : {for arn_suffix in local.target_group_arn_suffixes : "${arn_suffix}/${ma.name}" => merge(ma, { target_group = arn_suffix }) }
  ]...)
}

resource "aws_cloudwatch_metric_alarm" "target-groups" {
  for_each = local.all_tg_metric_alarms

  alarm_name          = "${local.resource_name}-${each.value.name}"
  comparison_operator = try(each.value.comparison_operator, null)
  evaluation_periods  = try(each.value.evaluation_periods, null)
  metric_name         = try(each.value.metric_name, null)
  namespace           = try(each.value.namespace, null)
  period              = try(each.value.period, null)
  statistic           = try(each.value.statistic, null)
  threshold           = try(each.value.threshold, null)
  alarm_description   = try(each.value.alarm_description, null)
  alarm_actions       = try(jsondecode(each.value.actions), null)

  dimensions = {
    TargetGroup = each.value.target_group
  }

  tags = local.tags
}
