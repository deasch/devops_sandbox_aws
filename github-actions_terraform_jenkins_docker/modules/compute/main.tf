variable "public_subnet" {
   description = "The public subnet IDs assigned to the Jenkins server"
}

variable "vpc_id" {
   description = "ID of the VPC"
   type        = string
}

variable "my_ip" {
   description = "My IP address"
   type = string
}





data "aws_ami" "ubuntu" {
   most_recent = "true"

   filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
   }

   filter {
      name = "virtualization-type"
      values = ["hvm"]
   }

   owners = ["amazon"]
}

resource "aws_instance" "jenkins_server" {
   ami = data.aws_ami.ubuntu.id
   subnet_id = var.public_subnet
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.aws_jenkins_sg.id]
   key_name = aws_key_pair.aws_kp.key_name
   user_data = "${file("${path.module}/install_jenkins.sh")}"

   tags = {
      Name = "jenkins_server"
   }
}

resource "aws_key_pair" "aws_kp" {
   key_name = "aws_kp"
   public_key = file("${path.module}/aws_kp.pub")
}

resource "aws_eip" "jenkins_eip" {
   instance = aws_instance.jenkins_server.id
   vpc      = true

   tags = {
      Name = "jenkins_eip"
   }
}

resource "aws_security_group" "aws_jenkins_sg" {
   name = "aws_jenkins_sg"
   description = "Security group for jenkins server"
   vpc_id = var.vpc_id

   ingress {
      description = "Allow all traffic through port 8080"
      from_port = "8080"
      to_port = "8080"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      description = "Allow SSH from my computer"
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["${var.my_ip}/32"]
   }

   egress {
      description = "Allow all outbound traffic"
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "aws_jenkins_sg"
   }
}





output "public_ip" {
   description = "The public IP address of the Jenkins server"
   value = aws_eip.jenkins_eip.public_ip
}
