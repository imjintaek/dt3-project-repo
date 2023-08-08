output "igw_route_table_id" {
    description     =   "The ID of Route Table for igw"
    value           =   aws_route_table.igw.id
}

output "vpce1_id" {
    description     =   "The ID of VPCE"
    value           =  element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == var.subnet_ids[0]], 0)
  }
  
output "vpce2_id" {
    description     =   "The ID of VPCE"
    value           =  element([for ss in tolist(aws_networkfirewall_firewall.fw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.attachment[0].subnet_id == var.subnet_ids[1]], 0)
  }
  
