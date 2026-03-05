locals {
  // disable_main_port_mapping dictates whether the main container should map a port to the network
  // If the user specifies service_port=0, then that will disable
  // If a capability sidecar specifies as owns_service_port=true, then that will also disable
  disable_main_port_mapping = !(var.port > 0) || anytrue(values(local.sidecars_owns_service_port))

  cap_lb_ports = toset(concat([var.port], [for lb in local.capabilities.load_balancers : lb.port]))
  // Exclude main port from all_port_mappings if disabled
  all_port_mappings = { for port in local.cap_lb_ports : port => { protocol = "tcp" } if !(port == tostring(var.port) && local.disable_main_port_mapping) }

  cap_target_groups = [
    for lb in local.capabilities.load_balancers : {
      capTfId = lb.cap_tf_id
      arn     = lb.target_group_arn

      // This strips the arn down to the target group name in the form: targetgroup/<name>/<id>
      arn_suffix = element(split(":", lb.target_group_arn), 5)
      name       = element(split("/", element(split(":", lb.target_group_arn), 5)), 1)
      id         = element(split("/", element(split(":", lb.target_group_arn), 5)), 2)
    }
  ]
}
