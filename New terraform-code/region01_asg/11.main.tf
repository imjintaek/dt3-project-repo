##################################################################################

module "s3" { #cloudfront
    
    source                  = "./modules/s3" 
    team                    =   local.team
    
    IMAGES_BUCKET_NAME      = "${local.team}-web-images-${local.region}"

    LOG_BUCKET_NAME         = "${local.team}-cf-log-${local.region}"
    BUCKET_OBJECT           = "images/logo.gif"

}

##################################################################################

module "vpc" {
    source                  =   "./modules/vpc"

    prefix                  =   local.prefix
    vpc_cidr                =   local.vpc_cidr

    public_fw_subnets       =   local.public_fw_subnets    
    public_subnets          =   local.public_subnets
    private_subnets         =   local.private_subnets
    
    admin_access_cidrs      =   local.admin_access_cidrs

    tags = {
    team                    =   local.team 
    }
    
}

module "load_balancer" {
    source                  =   "./modules/alb"
    
    prefix                  =   local.prefix
    vpc_id                  =   module.vpc.this_vpc_id
    port                    =   local.port
    protocol                =   local.protocol

    security_group_ids      =   [module.vpc.alb_security_group_id]
    subnet_ids              =   module.vpc.public_subnet_ids


    certificate_arn         =   aws_acm_certificate.acm_cert.arn

    tags = {
    team                    =   local.team   
    }
    
    depends_on              =   [ module.vpc, aws_acm_certificate.acm_cert ]
}

module "network_firewall" {
    source                  =   "./modules/network_firewall"
    
    prefix                  =   local.prefix
    vpc_id                  =   module.vpc.this_vpc_id
    vpc_cidr                =   local.vpc_cidr
    subnet_ids              =   module.vpc.public_fw_subnet_ids
    #igw_route_table_id      =   module.vpc.igw_route_table_id                                             
    igw_id                  =   module.vpc.this_internet_gateway_id                                       #for ingress
    public_route_table_ids  =   [module.vpc.public_a_route_table_id, module.vpc.public_c_route_table_id]  #for egress
    
    public_subnets          =   local.public_subnets
    cloud9_access_cidr      =   local.cloud9_access_cidr
    
    tags = {
    team                    =   local.team   
    }
    
    depends_on              =   [module.vpc]
}



module  "auto_scaling_group" {
    source                  =   "./modules/auto_scaling_group"
    
    prefix                  =   local.prefix

    image_id                =   local.image_id
    instance_type           =   local.instance_type
    keypair_name            =   local.keypair_name
    # data_vol_snapshot_id    =   var.data_vol_snapshot_id
    # data_volume_size        =   var.data_volume_size
    sns_email_address       =   local.sns_email_address    
    
    security_group_ids      =   [module.vpc.web_security_group_id, module.vpc.admin_security_group_id]  ### 실배포에는 web만
    subnet_ids              =   module.vpc.private_subnet_ids
    target_group_arns       =   [module.load_balancer.web_target_group_arn]
    
    max_size                =   local.max_size
    min_size                =   local.min_size
    desired_capacity        =   local.desired_capacity

    image_object_uri        =   module.s3.s3_object_uri
    
    tags = {
    team                    =   local.team
    }
    
    depends_on              =   [module.vpc, module.load_balancer, module.s3]

}
