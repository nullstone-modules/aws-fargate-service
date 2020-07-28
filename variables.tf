variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_block" {
  type = string
}

variable "env" {
  type = string
}

variable "backend_conn_str" {
  type = string
}


variable "service_cpu" {
  type    = number
  default = 256
}

variable "service_memory" {
  type    = number
  default = 512
}

locals {
  network_block = data.terraform_remote_state.cluster.outputs.network_block
}
