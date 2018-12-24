pipeline {
  agent {
    docker {
      image 'terraform-base:latest'
      url 'https://hub.docker.com/r/semperfi93/terraform-base'
    }
  }
  environment {
     AWS_DEFAULT_REGION = 'eu-central-1'
  }

  stages {
    stage('Validate & lint') {
      parallel {
        stage('terraform fmt') {
          steps {
            checkout scm
            sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
          }
        }
      }
    }
  }
}