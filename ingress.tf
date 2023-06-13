locals {
  // disable_main_port_mapping dictates whether the main container should map a port to the network
  // If the user specifies service_port=0, then that will disable
  // If a capability sidecar specifies as owns_service_port=true, then that will also disable
  disable_main_port_mapping = !(var.port > 0) || anytrue(values(local.sidecars_owns_service_port))

  cap_load_balancers   = lookup(local.capabilities, "load_balancers", [])
  cap_port_mappings    = { for lb in local.cap_load_balancers : lb.port => { protocol = "tcp" } if lb.port != tostring(var.port) }
  prelim_port_mappings = merge(tomap({ (var.port) = { protocol = "tcp" } }), local.cap_port_mappings)
  // Exclude main port from all_port_mappings if disabled
  all_port_mappings = { for port, obj in local.prelim_port_mappings : port => obj if !(port == tostring(var.port) && local.disable_main_port_mapping) }
}
