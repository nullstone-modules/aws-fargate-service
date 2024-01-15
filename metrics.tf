locals {
  service_dims = tomap({
    "ClusterName" = local.cluster_name
    "ServiceName" = aws_ecs_service.this.name
  })

  metrics_cpu_mappings = {
    name = "cpu"
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
  }

  metrics_memory_mappings = {
    name = "memory"
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

  metrics_mappings = concat(local.metrics_cpu_mappings, local.metrics_memory_mappings)
}

