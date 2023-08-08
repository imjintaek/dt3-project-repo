# ############################################################################################################
# ### Requestor 쪽만 기재
# ############################################################################################################
# #tgw peering auto-accept 가 안되는 오류 증상이 있어 연결만 수동으로 진행
# #Ref : https://github.com/hashicorp/terraform-provider-aws/issues/23828
# 1) Seoul tgw peering attach 생성 to Tokyo tgw ID
# 2) Tokyo tgw peering attach 연결 수락
# 3) Seoul tgw route table 에서 peering attach ID 대상 association 만들고 Tokyo CIDR로 정적경로 생성
# 4) Tokyo tgw route table 에서 peering attach ID 대상 association 만들고 Seoul CIDR로 정적경로 생성
# ############################################################################################################

# provider "aws" {
#   alias  = "tokyo"
#   region = "ap-northeast-1"
# }

# data "aws_region" "peer" {
#   provider = aws.tokyo
# }

# ######################################################################

#
# [주의!] 
# 0. 동일 코드를 두개의 폴더로 분리 peer1, peer2
# 1. peer2는 vpc_peering모듈X, vpc일부 코드 실행차단, variables.tf 수정
# 2. peer2 리전의 VPC 및 구성을 먼저 생성후
# 3. 아래 코드 활성화후 peer1 수행
# 4. terraform apply : peer1은 자동으로 완료
# 5. peer2 리전에서 수동으로 accept 수행
# 6. peer2 vpc추가 코드 활성화후 다시 적용 

# ############################################################################################################

#Create Transit Gateway
resource "aws_ec2_transit_gateway" "thistgw" {
  description = "${local.tgw_region} Transit Gateway"
  auto_accept_shared_attachments = "enable"
  dns_support                     = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  tags = {
      Name = "${local.tgw_region}-tgw"
  }
}

#Attach VPC Public subnet to TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "region_vpc_tgw_attach" {
  vpc_id             = module.vpc.this_vpc_id              #서브넷이 위치하는 VPC
  subnet_ids         = [module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1]]      #TGW에 붙을 서브넷
  transit_gateway_id = aws_ec2_transit_gateway.thistgw.id     #붙을 대상이되는 TGW
  tags = {
      Name = "${local.tgw_region}-vpc-tgw-attach"
  }
  
  depends_on              =   [ module.vpc ]  
}

resource "aws_ec2_transit_gateway_route_table" "thistgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.thistgw.id
  tags = {
      Name = "${local.tgw_region}-tgw-rt"
  }
}

# resource "aws_ec2_transit_gateway_route" "example" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
# }

resource "aws_ec2_transit_gateway_route_table_association" "thistgw_rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.region_vpc_tgw_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.thistgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "thistgw_rt" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.region_vpc_tgw_attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.thistgw_rt.id
}

#### 정적 경로 생성 참고
# resource "aws_ec2_transit_gateway_route" "example" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.example.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.example.association_default_route_table_id
# }

### Add Route FROM PUB/PRIV Subnet RT TO PEER


resource "aws_route" "pub_a_region_vpc_tgw_attach" {
    route_table_id             =    module.vpc.public_a_route_table_id
    destination_cidr_block     =    local.peer_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.thistgw.id
    #depends_on          =   [aws_networkfirewall_firewall.fw]
}

resource "aws_route" "pub_c_region_vpc_tgw_attach" {
    route_table_id             =    module.vpc.public_c_route_table_id
    destination_cidr_block     =    local.peer_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.thistgw.id
    #depends_on          =   [aws_networkfirewall_firewall.fw]
}

resource "aws_route" "priv_a_region_vpc_tgw_attach" {
    route_table_id             =    module.vpc.private_a_route_table_id
    destination_cidr_block     =    local.peer_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.thistgw.id
    #depends_on          =   [aws_networkfirewall_firewall.fw]
}

resource "aws_route" "priv_c_region_vpc_tgw_attach" {
    route_table_id             =    module.vpc.private_c_route_table_id
    destination_cidr_block     =    local.peer_cidr_block
    transit_gateway_id = aws_ec2_transit_gateway.thistgw.id
    #depends_on          =   [aws_networkfirewall_firewall.fw]
}

