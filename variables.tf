variable "num_tasks" {
  type        = number
  default     = 1
  description = <<EOF
The desired number of tasks for this application to run.
A task consists of the primary application container and any supporting containers that may be added via capabilities.
EOF
}

variable "cpu" {
  type        = number
  default     = 256
  description = <<EOF
The amount of CPU units to reserve for the service.
1024 CPU units is roughly equivalent to 1 vCPU.
This means the default of 256 CPU units is roughly .25 vCPUs.
A vCPU is a virtualization of a physical CPU.
EOF
}

variable "memory" {
  type        = number
  default     = 512
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in MiB, or megabytes.
This means the default is 512 MiB or 0.5 GiB.
EOF
}

variable "image" {
  type        = string
  default     = ""
  description = <<EOF
The docker image to deploy for this service.
By default, this is blank, which means that an ECR repo is created and used.
Use this variable to configure against docker hub, quay, etc.
EOF
}

variable "command" {
  type        = list(string)
  default     = []
  description = <<EOF
This overrides the `CMD` specified in the image.
Specify a blank list to use the image's `CMD`.
Each token in the command is an item in the list.
For example, `echo "Hello World"` would be represented as ["echo", "\"Hello World\""].
EOF
}

variable "port" {
  type        = number
  default     = 80
  description = <<EOF
The port that the service is listening on.
This is set to port 80 by default; however, if the service in the container is a non-root user,
the service will fail due to bind due to permission errors.
Specify 0 to disable network connectivity to this container.
EOF
}

variable "ephemeral_storage" {
  type        = number
  default     = 20
  description = <<EOF
The amount of ephemeral disk space (in GiB) allocated to the app.
AWS supports 20 - 200 GiB of ephemeral disk space.
By default, AWS grants 20 GiB.
EOF

  validation {
    condition     = var.ephemeral_storage > 19
    error_message = "AWS does not support ephemeral storage smaller than 20 GiB."
  }

  validation {
    condition     = var.ephemeral_storage <= 200
    error_message = "AWS does not support ephemeral storage larger than 200 GiB."
  }
}
