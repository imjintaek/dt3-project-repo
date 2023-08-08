variable "prefix" {}
variable "vpc_cidr" {}

variable "public_fw_subnets" {
    type = list(object({
        cidr                =   string
        availability_zone   =   string
        az_code             =   string
    }))
}

variable "public_subnets" {
    type = list(object({
        cidr                =   string
        availability_zone   =   string
        az_code             =   string
    }))
}

variable "private_subnets" {
    type = list(object({
        cidr                =   string
        availability_zone   =   string
        az_code             =   string
    }))
}

variable "admin_access_cidrs" {
    type = list(string)
}


variable "tags" {
  type        = map(string)
  default     = {}
}
