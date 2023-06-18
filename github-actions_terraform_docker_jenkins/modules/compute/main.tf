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





resource "aws_instance" "jenkins_server" {
   ami = "ami-0b2ac948e23c57071"
   subnet_id = var.public_subnet
   instance_type = "t2.micro"
   count = 1
   vpc_security_group_ids = [aws_security_group.aws_jenkins_sg.id]

   #key_name = aws_key_pair.aws_kp.key_name
   key_name = "devops_sandbox_aws"
   
   user_data = "${file("${path.module}/install_docker_jenkins.sh")}"

   tags = {
      Name = "jenkins_server"
   }
}


resource "docker_image" "jenkins" {
   name = "jenkins_configured"
   
   build {
      path = "${file("${path.module}/")}"
      dockerfile = "Dockerfile"
   }
}


#resource "aws_key_pair" "aws_kp" {
   #key_name = "aws_kp"
   #public_key = file("${path.module}/aws_kp.pub")
#}

resource "aws_eip" "jenkins_eip" {
   instance = aws_instance.jenkins_server[0].id
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
      cidr_blocks = ["0.0.0.0/0"]
      #cidr_blocks = ["${var.my_ip}/32"]
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
