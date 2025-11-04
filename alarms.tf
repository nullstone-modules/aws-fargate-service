locals {
  tg_metric_alarms = merge([
    for ma in local.capabilities.metric_alarms : { for tg in local.cap_target_groups : "${tg.capTfId}-${ma.cap_tf_id}-${ma.name}" =>
      merge(ma, {
        alarm_name   = "${tg.name}-${tg.id}-${ma.name}-${random_string.resource_suffix.result}"
        target_group = tg.arn_suffix
      })
    } if ma.type == "target-group"
  ]...)
}

resource "aws_cloudwatch_metric_alarm" "target-groups" {
  for_each = local.tg_metric_alarms

  alarm_name          = each.value.alarm_name
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
