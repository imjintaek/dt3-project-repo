# Route table (Public_fw)
resource "aws_route_table" "public_fw" {
    vpc_id              =   aws_vpc.this.id

    tags = {
        Name            =   "${var.prefix}-public-fw-rt"
        Managed_by      =   "terraform"
    }
}

# Route table (Public)
resource "aws_route_table" "public_a" {
    vpc_id              =   aws_vpc.this.id

    tags = {
        Name            =   "${var.prefix}-public-a-rt"
        Managed_by      =   "terraform"
    }
}

resource "aws_route_table" "public_c" {
    vpc_id              =   aws_vpc.this.id

    tags = {
        Name            =   "${var.prefix}-public-c-rt"
        Managed_by      =   "terraform"
    }
}

# Route table (Private)
resource "aws_route_table" "private_a" {
    vpc_id              =   aws_vpc.this.id

    tags = {
        Name            =   "${var.prefix}-private-a-rt"
        Managed_by      =   "terraform"
    }
}

resource "aws_route_table" "private_c" {
    vpc_id              =   aws_vpc.this.id

    tags = {
        Name            =   "${var.prefix}-private-c-rt"
        Managed_by      =   "terraform"
    }
}

#Add route to go to the Internet Gateway for public_fw
resource "aws_route" "internet_gateway_fw" {
    route_table_id             =    aws_route_table.public_fw.id
    destination_cidr_block     =    "0.0.0.0/0"
    gateway_id                 =    aws_internet_gateway.this.id
}

########################################################################
# Add route to go to the Internet Gateway for public  
# DELETE BELOW LINES  WHEN DEPLOYING NEWORK FIREWALL
########################################################################

# resource "aws_route" "internet_gateway_a" {
#     route_table_id             =    aws_route_table.public_a.id
#     destination_cidr_block     =    "0.0.0.0/0"
#     gateway_id                 =    aws_internet_gateway.this.id
# }

# resource "aws_route" "internet_gateway_c" {
#     route_table_id             =    aws_route_table.public_c.id
#     destination_cidr_block     =    "0.0.0.0/0"
#     gateway_id                 =    aws_internet_gateway.this.id
# }

#REFER TO THE ../network_firewall/03.firewall_route_table.tf

########################################################################


resource "aws_route_table_association" "public_fw" {
    count               =   length(var.public_fw_subnets)
    
    subnet_id           =   "${aws_subnet.public_fw[count.index].id}"
    route_table_id      =   aws_route_table.public_fw.id
    
    depends_on          =   [aws_subnet.public_fw]
}

resource "aws_route_table_association" "public_a" {
    #count               =   length(var.public_subnets)
    
    subnet_id           =   "${aws_subnet.public[0].id}"
    route_table_id      =   aws_route_table.public_a.id
    
    depends_on          =   [aws_subnet.public]
}

resource "aws_route_table_association" "public_c" {
    #count               =   length(var.public_subnets)
    
    subnet_id           =   "${aws_subnet.public[1].id}"
    route_table_id      =   aws_route_table.public_c.id
    
    depends_on          =   [aws_subnet.public]
}


resource "aws_route_table_association" "private_a" {
    #count               =   length(var.public_subnets)
    
    subnet_id           =   "${aws_subnet.private[0].id}"
    route_table_id      =   aws_route_table.private_a.id
    
    depends_on          =   [aws_subnet.private]
}

resource "aws_route_table_association" "private_c" {
    #count               =   length(var.public_subnets)
    
    subnet_id           =   "${aws_subnet.private[1].id}"
    route_table_id      =   aws_route_table.private_c.id
    
    depends_on          =   [aws_subnet.private]
}