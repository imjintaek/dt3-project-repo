variable "prefix" {}

variable "image_id" {}
variable "instance_type" {}
variable "keypair_name" {}

variable "sns_email_address" {
    type    =   string
}

variable "security_group_ids" {
    type    =   list(string)
}

variable "subnet_ids" {
    type    =   list(string)
}

variable "target_group_arns" {}

variable "max_size" {
    type    =   number
}

variable "min_size" {
    type    =   number
}

variable "desired_capacity" {
    type    =   number
}

# variable "data_vol_snapshot_id" {}
# variable "data_volume_size" {}
variable "image_object_uri" {
    type    =   string
}

variable "tags" {
  type        = map(string)
  default     = {}
}
