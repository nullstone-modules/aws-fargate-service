locals {
  ulimits = lookup(local.capabilities, "ulimits", null)
}
