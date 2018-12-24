// pipeline {
//   agent {
//     docker {
//       image 'semperfi93/terraform-base:latest'
//       args '-it --entrypoint=/bin/bash'
//       registryUrl 'https://hub.docker.com/r/semperfi93/terraform-base'
//     }
//   }
//   environment {
//      AWS_DEFAULT_REGION = 'eu-central-1'
//   }

//   stages {
//     stage('Validate & lint') {
//       parallel {
//         stage('terraform fmt') {
//           steps {
//             checkout scm
//             sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
//           }
//         }
//       }
//     }
//   }
// }
pipeline {
    agent {
        docker { 
            image 'hashicorp/terraform:light' 
            args '-it --entrypoint=/bin/bash'
            label 'support_ubuntu_docker'
        }
    }
    stages {
        stage('Test') {
            steps {
                sh 'terraform --version'
            }
        }
    }
}
