pipeline {
  agent any
  environment {
     AWS_DEFAULT_REGION = 'eu-central-1'
  }

  stages {
    stage('terraform fmt') {
      steps {
        checkout scm
        sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
      }
    }
  }
}
// pipeline {
//     agent {
//         docker { 
//             image 'hashicorp/terraform:light' 
//             args '-it --entrypoint=bash'
//         }
//     }
//     stages {
//         stage('Test') {
//             steps {
//                 sh 'terraform --version'
//             }
//         }
//     }
// }
