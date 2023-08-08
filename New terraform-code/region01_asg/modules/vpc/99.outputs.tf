output "this_vpc_id" {
    description     =   "The ID of VPC"
    value           =   aws_vpc.this.id
}

output "this_vpc_cidr_block" {
    description     =   "The CIDR IP Range Block of VPC"
    value           =   aws_vpc.this.cidr_block
}

output "public_fw_subnet_ids" {
    description     =   "The List of Public_fw Subnet ID of VPC"
    value           =   aws_subnet.public_fw.*.id
}

output "public_subnet_ids" {
    description     =   "The List of Public Subnet ID of VPC"
    value           =   aws_subnet.public.*.id
}

output "private_subnet_info" {
    description     =   "map(any) of subnets raw info"
    value           =   aws_subnet.private
}

output "private_subnet_ids" {
    description     =   "The List of Private Subnet ID of VPC"
    value           =   aws_subnet.private.*.id
}

output "this_internet_gateway_id" {
    description     =   "The ID of Internet Gateway of VPC"
    value           =   aws_internet_gateway.this.id
}



output "public_fw_route_table_id" {
    description     =   "The ID of Route Table for Public_fw Subnet"
    value           =   aws_route_table.public_fw.id
}

output "public_a_route_table_id" {
    description     =   "The ID of Route Table for Public Subnet_a"
    value           =   aws_route_table.public_a.id
}

output "public_c_route_table_id" {
    description     =   "The ID of Route Table for Public Subnet_c"
    value           =   aws_route_table.public_c.id
}

output "private_a_route_table_id" {
    description     =   "The ID of Route Table for Private Subnet_a"
    value           =   aws_route_table.private_a.id
}

output "private_c_route_table_id" {
    description     =   "The ID of Route Table for Private Subnet_c"
    value           =   aws_route_table.private_c.id
}

output "this_a_nat_gateway_id" {
    description     =   "The ID of NAT Gateway_a of VPC"
    value           =   aws_nat_gateway.this_a.id
}

output "this_c_nat_gateway_id" {
    description     =   "The ID of NAT Gateway_c of VPC"
    value           =   aws_nat_gateway.this_c.id
}

output "admin_security_group_id" {
    description     =   "The ID of Security Group for Admin access"
    value           =   aws_security_group.admin.id
}

output "alb_security_group_id" {
    description     =   "The ID of Security Group for ALB"
    value           =   aws_security_group.alb.id
}

output "web_security_group_id" {
    description     =   "The ID of Security Group for Web(HTTP) access from ALB"
    value           =   aws_security_group.web.id
}

