
variable "public_key_content" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmRfj7VXY7fRumQtAcKedy9RsHwToevrN4Ntm81D9W4fjyAHJurCJi+VO4B2w9g2aCq+KxuZniNITVkbySi9qGRJmJAUO+d/X0yRMCnLyOMdbHM3bYMscMey2An/i8dlek73iEY3cml3Pq9WvWItGQzwBFOTe2NLViCkzsdfikWE/JPcn25YAjUsoZMF5S3TQ6Q3HpfaDtGHwnx1LQqbd7fVNzi5KmedhCUxIQwNfiCSgu0eAyMpZc9hqqqK3U6vDyKO3NSbypmiDGaxUdTBd1BW+6wKyJXb8"
}

resource "aws_key_pair" "public_key" {
  key_name   = "id_rsa.pub"
  public_key = var.public_key_content
}
  # ### VARs for VPC Network ################################################################
locals {
  prefix              =       "Region02"
  region              =       "ap-northeast-2"
  
  aws_region_code     =       "an2"            # Region Alias
    
  vpc_cidr            =       "20.4.0.0/16"

  public_fw_subnets      =       [
      {cidr = "20.4.1.0/24", availability_zone = "ap-northeast-2a", az_code = "2a"},
      {cidr = "20.4.11.0/24", availability_zone = "ap-northeast-2c", az_code = "2c"},
      ]
  
  public_subnets      =       [
      {cidr = "20.4.2.0/24", availability_zone = "ap-northeast-2a", az_code = "2a"},
      {cidr = "20.4.22.0/24", availability_zone = "ap-northeast-2c", az_code = "2c"},
      ]

  private_subnets = [
      {cidr = "20.4.3.0/24", availability_zone = "ap-northeast-2a", az_code = "2a"},
      {cidr = "20.4.33.0/24", availability_zone = "ap-northeast-2c", az_code = "2c"},
  ]

  admin_access_cidrs          =   ["20.4.0.0/16","218.50.140.95/32"                       ## asg에 접근할 access IP 추가 ex) 별도 bastion (Public) 추가 구성 등등..
                                    ,"3.36.61.182/32"]                                   ## CLOUD 9 PUBLIC IP
  
  # ### VARs for Auto Scaling Group ################################################################
  # image_id                      =   "ami-0c6e5afdd23291f73"                                ## ap-northeast-2 는 "ami-0c6e5afdd23291f73"

  # instance_type           =       "t3.micro"
  # keypair_name            =       aws_key_pair.public_key.key_name 
  # sns_email_address       =       "test@example.com"                                    ## SNS topic 받을 email
  # min_size                =       1
  # max_size                =       3
  # desired_capacity        =       2

  # ### VARs for ALB ###############################################################################
  # port                    =       "80"
  # protocol                =       "HTTP"  

 
  ### VARs for Transit Gateway #####################################################################
  tgw_region              =       "seoul"
  #peer_tgw_region        =       "tokyo"
  peer_cidr_block         =       "10.4.0.0/16"
  
  
  team = "4jo" # creator
} 

  ### VARs for EKS ONLY ############################################################################
locals {
    eks_vpc_id          = module.vpc.this_vpc_id
    #bastion_info        = module.ec2.out_ec2_info

    private_subnet_info = module.vpc.private_subnet_info    #map(any) of subnets raw info                              
    eks_subnets_cidr    = [local.private_subnets[0].cidr, local.private_subnets[1].cidr] #["20.4.3.0/24", "20.4.33.0/24"]
    
    admin_ip           = "3.36.61.182/32"
    admin_sg_id         = module.vpc.admin_security_group_id
    
    eks_node_public_key = aws_key_pair.public_key.key_name
}
