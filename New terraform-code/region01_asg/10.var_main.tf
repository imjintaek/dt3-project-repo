variable "public_key_content" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmRfj7VXY7fRumQtAcKedy9RsHwToevrN4Ntm81D9W4fjyAHJurCJi+VO4B2w9g2aCq+KxuZniNITVkbySi9qGRJmJAUO+d/X0yRMCnLyOMdbHM3bYMscMey2An/i8dlek73iEY3cml3Pq9WvWItGQzwBFOTe2NLViCkzsdfikWE/JPcn25YAjUsoZMF5S3TQ6Q3HpfaDtGHwnx1LQqbd7fVNzi5KmedhCUxIQwNfiCSgu0eAyMpZc9hqqqK3U6vDyKO3NSbypmiDGaxUdTBd1BW+6wKyJXb8+UnmQgjiMKI5KjhB18CL1gnaifsa1UBINAjBGJIeHdfYS0eFr0UVR"
}

resource "aws_key_pair" "public_key" {
  key_name   = "id_rsa.pub"
  public_key = var.public_key_content
}
  # ### VARs for VPC Network ################################################################
locals {
  prefix              =       "region01"
  region              =       "ap-northeast-1"
  
  aws_region_code     =       "an1"            # Region Alias
    
  vpc_cidr            =       "10.4.0.0/16"

  public_fw_subnets      =       [
      {cidr = "10.4.1.0/24", availability_zone = "ap-northeast-1a", az_code = "1a"},
      {cidr = "10.4.11.0/24", availability_zone = "ap-northeast-1c", az_code = "1c"},
      ]
  
  public_subnets      =       [
      {cidr = "10.4.2.0/24", availability_zone = "ap-northeast-1a", az_code = "1a"},
      {cidr = "10.4.22.0/24", availability_zone = "ap-northeast-1c", az_code = "1c"},
      ]

  private_subnets = [
      {cidr = "10.4.3.0/24", availability_zone = "ap-northeast-2a", az_code = "2a"},
      {cidr = "10.4.33.0/24", availability_zone = "ap-northeast-2c", az_code = "2c"},
  ]

  admin_access_cidrs          =   ["116.127.84.104/32","218.50.140.95/32","10.4.0.0/16"]
  cloud9_access_cidr          =   "52.78.52.144/32"
  
  # ### VARs for Auto Scaling Group ################################################################
  
  image_id                      =   "ami-0d52744d6551d851e"  #"ami-0d52744d6551d851e for tokyo"
  #data_vol_snapshot_id        =   "snap-0260cfecb65ccc269"
  #data_volume_size        =       "10"

  instance_type           =       "t3.micro"
  keypair_name            =       aws_key_pair.public_key.key_name
  sns_email_address       =       "dana@naver.com"
  min_size                =       1
  max_size                =       2
  desired_capacity        =       1
  
  # ### VARs for ALB ###############################################################################
  port                    =       "80"
  protocol                =       "HTTP"
  
  ### VARs for Transit Gateway #####################################################################
  tgw_region              =       "tokyo"
  #peer_tgw_region        =       "seoul"
  peer_cidr_block         =       "20.4.0.0/16"
  
  team = "4jo"

} 
