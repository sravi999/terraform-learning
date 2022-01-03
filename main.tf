terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.64.2"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
source="./modules/vpc"
vpc_cidr = var.vpc_cidr_block
name="Raviteja"
vpc_tags={
owner="ravi"
lab="AcloudGuru"
}
}
