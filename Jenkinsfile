pipeline {
  agent {
     docker { image 'semperfi93/terraform-base' }
  }
  environment {
     AWS_DEFAULT_REGION = 'eu-central-2'
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