locals {
  sidecars = lookup(local.capabilities, "sidecars", [])

  addl_container_defs = [for s in local.sidecars : merge(s, {
    name         = s.name
    image        = s.image
    essential    = lookup(s, "essential", false)
    portMappings = lookup(s, "portMappings", [])
    environment  = lookup(s, "environment", [])
    secrets      = lookup(s, "secrets", [])
    mountPoints  = lookup(s, "mountPoints", [])
    volumesFrom  = lookup(s, "volumesFrom", [])
    healthCheck  = lookup(s, "healthCheck", {})
    dependsOn    = lookup(s, "dependsOn", [])

    logConfiguration = local.log_configurations[0]
  })]
}
