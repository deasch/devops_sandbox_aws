#!/bin/bash
# https://medium.com/@raguyazhin/step-by-step-guide-to-install-jenkins-on-amazon-linux-bfce88dd5a9e


#Install Docker
sudo yum update
sudo yum upgrade
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo systemctl restart docker
sudo docker info








sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-11-amazon-corretto -y
sudo yum install jenkins -y

JAVA_OPTS='-Djenkins.install.runSetupWizard=false'

sudo systemctl enable jenkins
sudo systemctl start jenkins
