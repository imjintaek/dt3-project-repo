# VPC
resource "aws_vpc" "this" {
    cidr_block      =   var.vpc_cidr

    enable_dns_hostnames  = true                     # VPC Option - Enable DNS Hostname 활성화 여부
    enable_dns_support    = true                     # VPC Option - Enable DNS Support 활성화 여부
    instance_tenancy      = "default"                # VPC Option - instance tenancy 정보

    tags = {
        Name        =   "${var.prefix}-vpc"
        Managed_by  =   "terraform"
        team = "${var.tags.team}"
    }
}
