locals {
  service_dims = tomap({
    "ClusterName" = local.cluster_name
    "ServiceName" = aws_ecs_service.this.name
  })

  metrics_mappings = concat(local.base_metrics, local.cap_metrics)

  cap_metrics_defs = lookup(local.capabilities, "metrics", [])
  cap_metrics = [
    for m in local.cap_metrics_defs : {
      name = m.name
      type = m.type
      unit = m.unit

      mappings = {
        for metric_id, mapping in jsondecode(lookup(m, "mappings", "{}")) : metric_id => {
          account_id        = mapping.account_id
          dimensions        = mapping.dimensions
          stat              = lookup(mapping, "stat", null)
          namespace         = lookup(mapping, "namespace", null)
          metric_name       = lookup(mapping, "metric_name", null)
          expression        = lookup(mapping, "expression", null)
          hide_from_results = lookup(mapping, "hide_from_results", null)
        }
      }
    }
  ]

  base_metrics = [
    {
      name = "app/cpu"
      type = "usage"
      unit = "vCPU"

      mappings = {
        cpu_reserved = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuReserved"
          dimensions  = local.service_dims
        }
        cpu_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.service_dims
        }
        cpu_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.service_dims
        }
        cpu_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "CpuUtilized"
          dimensions  = local.service_dims
        }
      }
    },
    {
      name = "app/memory"
      type = "usage"
      unit = "MiB"

      mappings = {
        memory_reserved = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryReserved"
          dimensions  = local.service_dims
        }
        memory_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.service_dims
        }
        memory_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.service_dims
        }
        memory_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "ECS/ContainerInsights"
          metric_name = "MemoryUtilized"
          dimensions  = local.service_dims
        }
      }
    }
  ]
}

