
resource "aws_route_table" "igw" {
    vpc_id          =   var.vpc_id

    tags = {
        Name            =   "${var.prefix}-igw-rt"
        Managed_by      =   "terraform"
    }
}

resource "aws_route_table_association" "igw" {
  gateway_id     = "${var.igw_id}"
  route_table_id = aws_route_table.igw.id
}

resource "aws_route" "igw" {
    count                      =   length(var.public_subnets)
    route_table_id             =    aws_route_table.igw.id
    destination_cidr_block     =    "${lookup(var.public_subnets[count.index], "cidr")}"
    vpc_endpoint_id            =    element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == var.subnet_ids[count.index]], 0)
    #vpc_endpoint_id            =    element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == aws_subnet.inspection_vpc_firewall_subnet[count.index].id], 0)
    depends_on          =   [aws_networkfirewall_firewall.fw]
}


resource "aws_route" "gwlb_a" {
    route_table_id             =    var.public_route_table_ids[0]
    destination_cidr_block     =    "0.0.0.0/0"
    vpc_endpoint_id            =    element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == var.subnet_ids[0]], 0)

    depends_on          =   [aws_networkfirewall_firewall.fw]
}

resource "aws_route" "gwlb_c" {
    route_table_id             =    var.public_route_table_ids[1]
    destination_cidr_block     =    "0.0.0.0/0"
    vpc_endpoint_id            =    element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == var.subnet_ids[1]], 0)

    depends_on          =   [aws_networkfirewall_firewall.fw]
    
}