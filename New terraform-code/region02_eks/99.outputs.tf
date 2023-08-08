
# output "s3_bucket_id" {
#     description     =   "The ID of S3 Bucket"
#     value           =   module.s3.s3_bucket_id
# }

################################################################################


output "vpc_id" {
    description     =   "The ID of VPC"
    value           =   module.vpc.this_vpc_id
}

output "vpc_cidr_block" {
    description     =   "The CIDR IP Range Block of VPC"
    value           =   module.vpc.this_vpc_cidr_block
}

output "public_fw_subnet_ids" {
    description     =   "The List of Public_fw Subnet ID of VPC"
    value           =   module.vpc.public_fw_subnet_ids
}

output "public_subnet_ids" {
    description     =   "The List of Public Subnet ID of VPC"
    value           =   module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    description     =   "The List of Private Subnet ID of VPC"
    value           =   module.vpc.private_subnet_ids
}

output "admin_security_group_id" {
    description     =   "The ID of Security Group for Admin access"
    value           =   module.vpc.admin_security_group_id
}

output "alb_security_group_id" {
    description     =   "The ID of Security Group for ALB"
    value           =   module.vpc.alb_security_group_id
}

output "web_security_group_id" {
    description     =   "The ID of Security Group for Web(HTTP) access from ALB"
    value           =   module.vpc.web_security_group_id
}

# output "web_alb_arn" {
#     description     =   "The ARN of ALB"
#     value           =   module.load_balancer.web_alb_arn
# }

# output "web_alb_arn_suffix" {
#     description     =   "The ARN suffix of ALB"
#     value           =   module.load_balancer.web_alb_arn_suffix
# }

# output "web_alb_name" {
#     description     =   "The name of ALB"
#     value           =   module.load_balancer.web_alb_name
# }

# output "web_alb_dns_name" {
#     description     =   "The DNS name of ALB"
#     value           =   module.load_balancer.web_alb_dns_name
# }

# output "web_alb_zone_id" {
#     description     =   "The zone ID of ALB"
#     value           =   module.load_balancer.web_alb_zone_id
# }



# output "web_target_group_arn_suffix" {
#     description     =   "The ARN suffix of Target group"
#     value           =   module.load_balancer.web_target_group_arn_suffix
# }


# output "web_auto_scaling_group_id" {
#     description     =   "The ID of Auto Scaling Group"
#     value           =   module.auto_scaling_group.web_auto_scaling_group_id
# }

# output "web_launch_template_id" {
#     description     =   "The ID of Launch Template"
#     value           =   module.auto_scaling_group.web_launch_template_id
# }

# output "web_launch_configuration_id" {
#      description     =   "The ID of Launch Configuation"
#      value           =   module.auto_scaling_group.web_launch_configuration_id
#  }

# output "vpce1_id"{
#     description     =   "vpce id"
#     value           =   module.network_firewall.vpce1_id
# }

# output "vpce2_id"{
#     description     =   "vpce2 id"
#     value           =   module.network_firewall.vpce2_id
# }


# # web_images_cdn module block
# #------------------------------------------------------------------------------
# output "image_object_uri" {
# 	value = module.s3.s3_object_uri
# }

# output "cloudfront_domain_name" {
# 	value = module.s3.cloudfront_domain_name
# }
# #------------------------------------------------------------------------------

# # transit_gateway_id
# #------------------------------------------------------------------------------
# output "Seoul_transit_gateway_id" {
# 	value = aws_ec2_transit_gateway.thistgw.id
# }

