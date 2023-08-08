variable "prefix" {}

variable "vpc_id" {}
variable "vpc_cidr" {}


variable "subnet_ids" {
    type        =   list(string)
}

variable "cloud9_access_cidr" {}

variable "igw_id" {}

variable "public_subnets" {
    type = list(object({
        cidr                =   string
        availability_zone   =   string
        az_code             =   string
    }))
}

variable "public_route_table_ids" {
    type        =   list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
}

