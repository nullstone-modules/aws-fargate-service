locals {
  cap_mount_points = lookup(local.capabilities, "mount_points", [])

  mount_points = [for mp in local.cap_mount_points : { sourceVolume = mp.name, containerPath = mp.path }]
  volumes      = { for mp in local.cap_mount_points : mp.name => { efs_volume = lookup(mp, "efs_volume", "") } }
}
