# Security Group for SSH
resource "aws_security_group" "admin" {
  name                  =   "${var.prefix}-admin-sg"
  vpc_id                =   aws_vpc.this.id

  # Outbound ALL
  egress {
    from_port           =   0
    to_port             =   0
    protocol            =   "-1"
    cidr_blocks         =   ["0.0.0.0/0"]
  }

  tags = {
    Name                =   "${var.prefix}-admin-sg"
    Managed_by          =   "terraform"
  }
}

resource "aws_security_group_rule" "admin_access_ingress" {
  description           =   "Allow SSH for admin"
  cidr_blocks           =   var.admin_access_cidrs
  from_port             =   22
  to_port               =   22
  protocol              =   "tcp"
  security_group_id     =   aws_security_group.admin.id
  type                  =   "ingress"
}



# Security Group for Web (ALB)
resource "aws_security_group" "alb" {
  name                  =   "${var.prefix}-alb-sg"
  vpc_id                =   aws_vpc.this.id

  # Outbound ALL
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-alb-sg"
    Managed_by  = "terraform"
  }
}

resource "aws_security_group_rule" "http_access_ingress" {
  description           =   "Allow HTTP"
  cidr_blocks           =   ["0.0.0.0/0"]
  from_port             =   80
  to_port               =   80
  protocol              =   "tcp"
  security_group_id     =   aws_security_group.alb.id
  type                  =   "ingress"
}
resource "aws_security_group_rule" "https_access_ingress" {
  description           =   "Allow HTTPS"
  cidr_blocks           =   ["0.0.0.0/0"]
  from_port             =   443
  to_port               =   443
  protocol              =   "tcp"
  security_group_id     =   aws_security_group.alb.id
  type                  =   "ingress"
}


## ICMP TEST 용
#########################################################################
resource "aws_vpc_security_group_ingress_rule" "icmp_access_ingress" {
  description = "ICMP Test"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  ip_protocol = "icmp"
  to_port     = -1
}


# Security Group for Web Server
resource "aws_security_group" "web" {
  name                  =   "${var.prefix}-web-sg"
  vpc_id                =   aws_vpc.this.id

  # Outbound ALL
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-web-sg"
    Managed_by  = "terraform"
  }
}

resource "aws_security_group_rule" "alb_access_ingress" {
  description               =   "Allow HTTP from ALB Security Group"
  source_security_group_id  =   aws_security_group.alb.id
  from_port                 =   80
  to_port                   =   80
  protocol                  =   "tcp"
  security_group_id         =   aws_security_group.web.id
  type                      =   "ingress"
}

resource "aws_security_group_rule" "alb_access_ingress_https" {
  description               =   "Allow HTTPS from ALB Security Group"
  source_security_group_id  =   aws_security_group.alb.id
  from_port                 =   443
  to_port                   =   443
  protocol                  =   "tcp"
  security_group_id         =   aws_security_group.web.id
  type                      =   "ingress"
}

resource "aws_security_group_rule" "alb_access_ingress_icmp" {
  description               =   "Allow ICMP Test from ALB Security Group"
  source_security_group_id  =   aws_security_group.alb.id
  from_port                 =   1521
  to_port                   =   1521
  protocol                  =   "tcp"
  security_group_id         =   aws_security_group.web.id
  type                      =   "ingress"
}
