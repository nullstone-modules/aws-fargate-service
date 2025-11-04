locals {
  // This defines the outputs to expect from capability module outputs
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
