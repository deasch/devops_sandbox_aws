#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update && sudo apt upgrade -y
sudo apt install default-jre -y
sudo apt install jenkins -y


ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# https://abrahamntd.medium.com/automating-jenkins-setup-using-docker-and-jenkins-configuration-as-code-897e6640af9d
#ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins-configuration.yaml
#jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

sudo systemctl start jenkins
