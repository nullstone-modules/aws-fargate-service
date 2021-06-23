locals {
  entries        = jsondecode(file("capabilities/entries.json"))
  lb_objects     = [for entry in local.entries : try(entry.load_balancer, null)]
  load_balancers = [for lb in local.lb_objects : lb if lb != null]
}
