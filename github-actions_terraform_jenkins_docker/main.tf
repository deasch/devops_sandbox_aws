variable "aws_region" {
   default = "eu-central-1"
}

variable "vpc_cidr_block" {
   description = "CIDR block for VPC"
   type = string
   default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
   description = "CIDR block for public subnet"
   type = string
   default = "10.0.1.0/24"
}

variable "my_ip" {
   description = "Your IP address"
   type = string
   sensitive = true
}





terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
   region = var.aws_region
   #profile = "default"
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





output "jenkins_public_ip" {
   description = "The public IP address of the Jenkins server"
   value = module.ec2_instance.public_ip
}
