# set aws provider specific version
# https://www.terraform.io/docs/language/settings/index.html
terraform {
  required_providers {
    aws = {
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  required_version = ">= 0.14"
}


# set aws as a provider
provider "aws" {
  profile = "default"
  region = "eu-central-1"
}


# default vpc
# Virtual Private Cloud (VPC) is a virtual network that you define to secure and easy access to resources.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc
resource "aws_default_vpc" "this" {}


# security groups to enable ports
# Security Group acts as a virtual firewall for controlling traffic of instances.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "this" {
  vpc_id  = aws_default_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Key Pair
# It is a combination of a public and private key that is used to encrypt or decrypt data.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "this" {
  key_name   = "my_demo_key"
  public_key = file("my_demo_key.pub")
}


# EC2 (Elastic Compute Cloud)
# It is a virtual machine or a server that runs your applications in the cloud.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "this" {
  count                  = "2" # instances: 1st for staging/live env and 2nd for jenkins pipelines.
  ami                    = "ami-0747bdcabd34c712a" # Ubuntu (us-east-1)
  instance_type          = "t2.micro" # free tier
  key_name               = aws_key_pair.this.key_name # authorized the machine, so we can login later on.
  vpc_security_group_ids = [aws_security_group.this.id]
}


# Output
output "public_ip" {
  value = aws_instance.this.*.public_ip
}
output "public_dns" {
  value = aws_instance.this.*.public_dns
}
