# Subnet (Public_fw)
resource "aws_subnet" "public_fw" {
    count               =   length(var.public_fw_subnets)

    vpc_id              =   aws_vpc.this.id
    cidr_block          =   "${lookup(var.public_fw_subnets[count.index], "cidr")}"
    availability_zone   =   "${lookup(var.public_fw_subnets[count.index], "availability_zone")}"

    tags = {
        Name        =   "${var.prefix}-public-fw-subnet-${var.public_fw_subnets[count.index].az_code}-${var.public_fw_subnets[count.index].cidr}"
        Managed_by  =   "terraform"
    }
}

# Subnet (Public)
resource "aws_subnet" "public" {
    count               =   length(var.public_subnets)

    vpc_id              =   aws_vpc.this.id
    cidr_block          =   "${lookup(var.public_subnets[count.index], "cidr")}"
    availability_zone   =   "${lookup(var.public_subnets[count.index], "availability_zone")}"

    tags = {
        Name        =   "${var.prefix}-public-subnet-${var.public_subnets[count.index].az_code}-${var.public_subnets[count.index].cidr}"
        Managed_by  =   "terraform"
        "kubernetes.io/cluster/eks-cluster-Region02-an2" = "shared"
        "kubernetes.io/role/elb"                         = "1"
    }
}

# Subnet (Private)
resource "aws_subnet" "private" {
    count               =   length(var.public_subnets)
    
    vpc_id              =   aws_vpc.this.id
    cidr_block          =   "${lookup(var.private_subnets[count.index], "cidr")}"
    availability_zone   =   "${lookup(var.public_subnets[count.index], "availability_zone")}"
    
    tags = {
        Name        =   "${var.prefix}-private-subnet-${var.private_subnets[count.index].az_code}-${var.private_subnets[count.index].cidr}"
        Managed_by  =   "terraform"
    }
}