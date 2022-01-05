terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.64.2"
    }
  }
  required_version = "~> 1.0.11"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "az" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name            = "my-vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.az.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
