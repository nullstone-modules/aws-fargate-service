variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "force_destroy" {
  type    = bool
  default = false
}

resource "random_uuid" "bucket_name" {}

locals {
  bucket_name = random_uuid.bucket_name.result
}
