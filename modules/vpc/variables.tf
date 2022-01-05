variable "vpc_name" {
default="my_vpc"
}

variable "vpc_cidr" {
type=string
default="172.0.0.0/16"
}

variable "vpc_tags" {
type=map
default={
terraform = "true"
environment= "dev"
}
}

variable "name" {
type=string
default="VPC"
}
