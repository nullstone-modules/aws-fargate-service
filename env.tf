locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV           = data.ns_workspace.this.env_name
    NULLSTONE_PUBLIC_HOSTS  = join(",", local.public_hosts)
    NULLSTONE_PRIVATE_HOSTS = join(",", local.private_hosts)
  })

  env_vars = [for k, v in merge(local.standard_env_vars, local.cap_env_vars, var.service_env_vars) : { name = k, value = v }]
}
