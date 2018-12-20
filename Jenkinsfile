pipeline {
  agent any
  environment {
     AWS_DEFAULT_REGION = 'eu-central-1'
  }

  stages {
    stage('Validate & lint') {
      parallel {
        stage('terraform fmt') {
          agent { docker { image 'simonmcc/hashicorp-pipeline:latest' } }
          steps {
            checkout scm
            sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
          }
        }
      }
    }
  }
}