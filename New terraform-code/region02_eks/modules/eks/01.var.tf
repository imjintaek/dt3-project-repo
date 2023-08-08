#############################
###    Common Variable    ###
#############################

variable "prefix" {}

variable "vpc_id" {
  type        = string
}


variable "aws_region" {
  type        = string
}

variable "aws_region_code" {
  type        = string
}

variable "eks_subnet_ids" {
  type        = list(string)
}


variable "admin_ip" {
  type        = string
}

variable "admin_sg_id" {
  type        = string
}

variable "eks_node_public_key" {
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
