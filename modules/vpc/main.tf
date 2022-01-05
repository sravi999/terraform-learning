resource "aws_vpc" "vpc" {
cidr_block=var.vpc_cidr
tags = merge(
{
"Name" = format("%s", var.name)
},
var.vpc_tags
)
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.31.0.0/20"
  availability_zone = data.aws_availability_zones.az.names[0]
}

