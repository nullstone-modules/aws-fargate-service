locals {
  sidecars = lookup(local.capabilities, "sidecars", [])

  // Using jsondecode because all map values must be of the same type
  addl_container_defs = [for s in local.sidecars : {
    name      = s.name
    image     = s.image
    essential = tobool(lookup(s, "essential", false))
    portMappings = [for mapping in jsondecode(lookup(s, "portMappings", "[]")) : {
      protocol      = mapping.protocol
      containerPort = tonumber(mapping.containerPort)
      hostPort      = tonumber(mapping.hostPort)
    }]
    environment = jsondecode(lookup(s, "environment", "[]"))
    secrets     = jsondecode(lookup(s, "secrets", "[]"))
    mountPoints = jsondecode(lookup(s, "mountPoints", "[]"))
    volumesFrom = jsondecode(lookup(s, "volumesFrom", "[]"))
    healthCheck = jsondecode(lookup(s, "healthCheck", "null"))
    dependsOn   = jsondecode(lookup(s, "dependsOn", "[]"))

    logConfiguration = local.log_configuration
  }]

  // If a sidecar takes over the service_port, we will configure the load balancer against that container instead of "main"
  sidecars_owns_service_port = { for s in local.sidecars : s.name => tobool(lookup(s, "owns_service_port", false)) }
  lb_container_name          = try(compact([for name, owns in local.sidecars_owns_service_port : (owns == true ? name : "")])[0], "main")
}
