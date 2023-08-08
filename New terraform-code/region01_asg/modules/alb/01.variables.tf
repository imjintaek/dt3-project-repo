variable "prefix" {}

variable "vpc_id" {}

variable "port" {
    default     =   "80"
}

variable "protocol" {
    default     =   "HTTP"
}

variable "security_group_ids" {
    type        =   list(string)
}
variable "subnet_ids" {
    type        =   list(string)
}


variable "tags" {
  type        = map(string)
  default     = {}
}

variable "certificate_arn"  {}