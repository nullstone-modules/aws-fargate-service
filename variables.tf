variable "enable_lb" {
  type        = bool
  default     = true
  description = "Enable this to add a load balancer in front of the Fargate service."
}

variable "enable_https" {
  type        = bool
  default     = true
  description = "Enable this to force the load balancer to listen on HTTPS instead of HTTP."
}

variable "service_cpu" {
  type        = number
  default     = 256
  description = <<EOF
The amount of CPU units to reserve for the service.
1024 CPU units is roughly equivalent to 1 vCPU.
This means the default of 256 CPU units is roughly .25 vCPUs.
A vCPU is a virtualization of a physical CPU.
EOF
}

variable "service_memory" {
  type        = number
  default     = 512
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in MiB, or megabytes.
This means the default is 512 MiB or 0.5 GiB.
EOF
}

variable "service_image" {
  type        = string
  default     = ""
  description = <<EOF
The docker image to deploy for this service.
By default, this is blank, which means that an ECR repo is created and used.
Use this variable to configure against docker hub, quay, etc.
EOF
}

variable "service_env_vars" {
  type        = map(string)
  default     = {}
  description = <<EOF
The environment variables to inject into the service.
These are typically used to configure a service per environment.
It is dangerous to put sensitive information in this variable because they are not protected and could be unintentionally exposed.
EOF
}

variable "service_container_port" {
  type        = number
  default     = 80
  description = <<EOF
The port inside the container to expose externally.
This will be forwarded to port 80 externally.
This is set to port 80 by default; however, if the service in the container is a non-root user,
the service will fail due to bind due to permission errors.
EOF
}

resource "random_string" "resource_suffix" {
  length  = 8
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  resource_name = "${data.ns_workspace.this.block}-${random_string.resource_suffix.result}"
}
