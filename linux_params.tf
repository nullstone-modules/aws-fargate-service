locals {
  special_linux_params = []
  all_linux_params     = flatten(concat(local.capabilities.linux_parameters, local.special_linux_params))
  linux_params         = length(local.all_linux_params) > 0 ? merge([for lp in local.all_linux_params : lp]...) : null
}
