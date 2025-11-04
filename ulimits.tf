locals {
  ulimits = [for u in local.capabilities.ulimits : {
    name      = u.name
    softLimit = tonumber(u.softLimit)
    hardLimit = tonumber(u.hardLimit)
  }]
}
