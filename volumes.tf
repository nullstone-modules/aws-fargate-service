locals {
  mount_points = [for mp in local.capabilities.mount_points : { sourceVolume = mp.name, containerPath = mp.path }]

  explicit_volumes     = { for v in local.capabilities.volumes : v.name => { efs_volume = lookup(v, "efs_volume", "") } }
  mount_point_volumes  = { for mp in local.capabilities.mount_points : mp.name => { efs_volume = lookup(mp, "efs_volume", "") } }
  volumes              = merge(local.explicit_volumes, local.mount_point_volumes)
  efs_encryption_ports = { for i, key in sort(keys(local.volumes)) : key => (2999 - i) }
}
