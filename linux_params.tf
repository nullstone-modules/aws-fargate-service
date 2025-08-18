locals {
  cap_linux_params     = [for cp in local.cap_modules : lookup(cp.outputs, "linux_parameters", [])]
  special_linux_params = []
  all_linux_params     = flatten(concat(local.cap_linux_params, local.special_linux_params))
  linux_params         = length(local.all_linux_params) > 0 ? merge([for lp in local.all_linux_params : lp]...) : null
}
