#!/bin/bash
# https://medium.com/@raguyazhin/step-by-step-guide-to-install-jenkins-on-amazon-linux-bfce88dd5a9e
# https://faun.pub/running-dockerized-jenkins-in-aws-ec2-5e11c46f9501
# https://hackmamba.io/blog/2022/04/running-docker-in-a-jenkins-container/
# https://yallalabs.com/devops/jenkins/how-to-build-custom-jenkins-docker-image/


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
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl restart docker
sudo docker-compose --version


#Create Volume for Jenkins
sudo mkdir -p /home/ec2-user/jenkins_data/jenkins_home



#Create Docker Compose File
sudo bash -c 'cat << EOF > /home/ec2-user/jenkins_data/docker-compose.yml
version: "3"

services:
  jenkins:
    container_name: jenkins
    image: jenkins/jenkins
    ports:
      - "8080:8080"
    volumes:
      - "./jenkins_home:/var/jenkins_home"
EOF'


#Run the Docker Compose file
cd /home/ec2-user/jenkins_data/
sudo docker-compose up -d



#Standard docker approach
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
 apt-get -y install apache2

# Install apache and write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

# Configure apache
RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \ 
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \ 
 chmod 755 /root/run_apache.sh

EXPOSE 80

CMD /root/run_apache.sh


