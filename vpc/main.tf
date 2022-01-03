terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.64.2"
    }
  }
  required_version="~>1.0.11"   # Terraform version
}

locals {
  name   = (var.vpc_tags["name"] != "" ? var.vpc_tags["name"] : "VPC-${var.region}")
  owner  = var.vpc_tags["owner"]
  region = var.region
  common_tags = {
    Owner  = local.owner
    Name   = local.name
    Region = local.region
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = local.common_tags
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.31.0.0/20"
  availability_zone = data.aws_availability_zones.az.names[0]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.common_tags
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.common_tags
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags        = local.common_tags
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_block
  security_group_id = aws_security_group.allow_tls.id
}
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidr_block
  security_group_id = aws_security_group.allow_tls.id
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access to VM"
  vpc_id      = aws_vpc.vpc.id
  tags        = local.common_tags
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_block
  security_group_id = aws_security_group.allow_ssh.id
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidr_block
  security_group_id = aws_security_group.allow_ssh.id
}

resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.common_tags
}

resource "aws_network_acl_rule" "ingress" {
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "egress" {
  network_acl_id = aws_network_acl.network_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_interface" "subnet_association" {
  subnet_id       = aws_subnet.subnet.id
  security_groups = concat([aws_security_group.allow_tls.id, aws_security_group.allow_ssh.id])
}
