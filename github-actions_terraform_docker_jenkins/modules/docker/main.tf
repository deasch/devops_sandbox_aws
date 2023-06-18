terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "jenkins_configured" {
   provider     = docker.kreuzwerker_docker
   name = "jenkins_configured"
   
   build {
      path = "${file("${path.module}/")}"
      dockerfile = "jenkins_configured.Dockerfile"
   }
}



