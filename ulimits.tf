locals {
  ulimits = [for u in lookup(local.capabilities, "ulimits", null) : {
    name      = u.name
    softLimit = tonumber(u.softLimit)
    hardLimit = tonumber(u.hardLimit)
  }]
}
