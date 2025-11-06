locals {
  // This indicates which outputs are supported by this app module
  // When adding support for a new output, add it to this list; the output will be available at "local.capabilities.<output_name>"
  capability_output_names = [
    "env",
    "secrets",
    "load_balancers",
    "metric_alarms",
    "auto_scaling",
    "private_urls",
    "public_urls",
    "log_configurations",
    "mount_points",
    "volumes",
    "sidecars",
    "events",
    "ulimits",
    "linux_parameters",
    "metrics",
  ]
}
