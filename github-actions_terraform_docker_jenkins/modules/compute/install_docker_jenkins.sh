#!/bin/bash
# https://medium.com/@raguyazhin/step-by-step-guide-to-install-jenkins-on-amazon-linux-bfce88dd5a9e
# https://faun.pub/running-dockerized-jenkins-in-aws-ec2-5e11c46f9501


#Install Docker
sudo yum update -y
sudo yum upgrade
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo systemctl restart docker
sudo docker info


#Install Docker Compose
#sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-'uname -s' - 'uname -m' | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl restart docker
sudo docker-compose --version


#Create Volume for Jenkins
sudo mkdir -p /home/ec2-user/jenkins_data/jenkins_home


#Create Docker Compose File




sudo cd /home/ec2-user/jenkins_data
sudo bash -c 'cat << EOF > /home/ec2-user/jenkins_data/docker-compose.yml
version: "3"

services:
  jenkins:
    container_name: jenkins
    image: jenkins/jenkins:lts-jdk11
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - "/home/ec2-user/jenkins_data/jenkins_home:/var/jenkins_home"
EOF'


#Run the Docker Compose file
sudo docker-compose up -d





sudo cat > docker-compose.yml <<- "EOF"
version: '3'

services:
  jenkins:
    container_name: jenkins
    image: jenkins/jenkins:lts-jdk11
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - "/home/ec2-user/jenkins_data/jenkins_home:/var/jenkins_home"
EOF







sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-11-amazon-corretto -y
sudo yum install jenkins -y

JAVA_OPTS='-Djenkins.install.runSetupWizard=false'

sudo systemctl enable jenkins
sudo systemctl start jenkins
