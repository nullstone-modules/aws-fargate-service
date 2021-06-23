locals {
  entries        = jsondecode(file("capabilities/entries.json"))
  lb_objects     = [for entry in local.entries : try(entry.load_balancer, null)]
  load_balancers = [for lb in local.lb_objects : lb if lb != null]
}

locals {
  datastores      = jsondecode(file("capabilities/datastores.json"))
  ds_secrets_deep = [for ds in local.datastores : ds.secrets if ds.secrets != null]
  ds_secrets      = flatten(local.ds_secrets_deep)
  ds_env_deep     = [for ds in local.datastores : ds.env if ds.env != null]
  ds_env          = flatten(local.ds_env_deep)
  ds_sec_groups   = [for ds in local.datastores : ds.security_group if ds.security_group != null]
}

locals {
  all_env     = concat([], local.ds_env)
  all_secrets = concat([], local.ds_secrets)
}

resource "aws_security_group_rule" "this-to-datastore" {
  count = length(local.ds_sec_groups)

  security_group_id        = local.ds_sec_groups[count.index].id
  type                     = "egress"
  from_port                = local.ds_sec_groups[count.index].port
  to_port                  = local.ds_sec_groups[count.index].port
  protocol                 = local.ds_sec_groups[count.index].protocol
  source_security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "datastore-from-this" {
  count = length(local.ds_sec_groups)

  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  from_port                = local.ds_sec_groups[count.index].value.port
  to_port                  = local.ds_sec_groups[count.index].port
  protocol                 = local.ds_sec_groups[count.index].protocol
  source_security_group_id = local.ds_sec_groups[count.index].id
}
