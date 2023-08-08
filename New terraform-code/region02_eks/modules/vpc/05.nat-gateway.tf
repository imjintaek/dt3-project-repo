# EIP
resource "aws_eip" "this_a" {
  vpc               =   true

  depends_on        =   [aws_internet_gateway.this]
}

# NAT Gateway
resource "aws_nat_gateway" "this_a" {
  allocation_id     =   aws_eip.this_a.id
  subnet_id         =   aws_subnet.public[0].id

  tags = {
    Name            =   "${var.prefix}-nat-gw-${var.public_subnets[0].az_code}"
  }

  depends_on        =   [aws_internet_gateway.this]
}

resource "aws_route" "nat_gateway_a" {
    route_table_id             =    aws_route_table.private_a.id
    destination_cidr_block     =    "0.0.0.0/0"
    nat_gateway_id             =    aws_nat_gateway.this_a.id
}

################################################################################

# EIP
resource "aws_eip" "this_c" {
  vpc               =   true

  depends_on        =   [aws_internet_gateway.this]
}

# NAT Gateway
resource "aws_nat_gateway" "this_c" {
  allocation_id     =   aws_eip.this_c.id
  subnet_id         =   aws_subnet.public[1].id

  tags = {
    Name            =   "${var.prefix}-nat-gw-${var.public_subnets[1].az_code}"
  }

  depends_on        =   [aws_internet_gateway.this]
}

resource "aws_route" "nat_gateway_c" {
    route_table_id             =    aws_route_table.private_c.id
    destination_cidr_block     =    "0.0.0.0/0"
    nat_gateway_id             =    aws_nat_gateway.this_c.id
}
