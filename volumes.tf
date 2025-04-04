locals {
  cap_mount_points = lookup(local.capabilities, "mount_points", [])
  cap_volumes      = lookup(local.capabilities, "volumes", [])

  mount_points = [for mp in local.cap_mount_points : { sourceVolume = mp.name, containerPath = mp.path }]

  explicit_volumes    = { for v in local.cap_volumes : v.name => { efs_volume = lookup(v, "efs_volume", "") } }
  mount_point_volumes = { for mp in local.cap_mount_points : mp.name => { efs_volume = lookup(mp, "efs_volume", "") } }
  volumes             = merge(local.explicit_volumes, local.mount_point_volumes)
}
