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

    logConfiguration = local.log_configurations[0]
  }]
}
