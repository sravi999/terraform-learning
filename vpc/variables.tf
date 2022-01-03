variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "vpc_tags" {
  description = "VPC tags"
  type        = map(any)
  default = {
    name  = ""
    owner = "ravi"
  }
}

variable "route_table_cidr_block" {
  description = "Route table cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ingress_cidr_block" {
  description = "Security group inbound cidr block"
  type        = list(string)
  default     = ["14.192.1.83/32"]
}

variable "egress_cidr_block" {
  description = "Security group outbound cidr block"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instances" {
  description = "Instance configuration"
  type        = map(any)
  default = {
    instance = {
      instance_type = "t2.micro",
      environment   = "dev"
    }
  }
}

variable "instance_tags" {
  description = "Assign tag to instance using lookup function"
  type        = map(any)
  default = {
    web_server  = "Apache"
    environment = "dev"
  }
}
