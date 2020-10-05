variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "env" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_blocks" {
  type = object({
    cluster   = string
    subdomain = string
  })
}

variable "backend_conn_str" {
  type = string
}


variable "enable_lb" {
  type    = bool
  default = true
}

variable "enable_https" {
  type    = bool
  default = false
}

variable "service_cpu" {
  type    = number
  default = 256
}

variable "service_memory" {
  type    = number
  default = 512
}

variable "service_image_tag" {
  type    = string
  default = "latest"
}

variable "service_env_vars" {
  type    = list(object({
    name : string
    value : string
  }))
  default = []
}
