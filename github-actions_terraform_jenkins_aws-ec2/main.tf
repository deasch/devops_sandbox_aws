terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block           = var.vpc_cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
}

module "ec2_instance" {
  source         = "./modules/compute"
  public_subnet  = module.vpc.public_subnet_id
  vpc_id         = module.vpc.vpc_id
  my_ip          = var.my_ip
}
