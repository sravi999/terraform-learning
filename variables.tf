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
    name  = "my_vpc"
    owner = "ravi"
  }
}
