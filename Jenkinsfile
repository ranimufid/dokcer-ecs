pipeline {
  agent any
  environment {
    AWS_CREDS = credentials('terra-access');
    // AWS_ACCESS_KEY_ID = "${echo $AWS_CREDS | cut -d ":" -f1}"
    // AWS_SECRET_ACCESS_KEY = "${echo $AWS_CREDS | cut -d ":" -f1}"
    AWS_DEFAULT_REGION = 'eu-central-1'
    TF_S3_STATE_BUCKET = 'tf-state-file-myjenkins'
    TF_S3_STATE_BUCKET_KEY= 'dokcer-ecs'
  }   
  stages {
    stage('terraform fmt') {
      steps {
        checkout scm
        sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
      }
    }
    stage ('terraform init'){
      steps {
        sh "aws --version"
        sh "aws s3 ls"
        sh 'cd terraform/aws-rds; \
        terraform init \
          -backend-config="bucket=$TF_S3_STATE_BUCKET" \
          -backend-config="key=$TF_S3_STATE_BUCKET_KEY/terraform.tfstate" \
          -backend-config="region=eu-central-1" \
          -backend-config="private=private" \
          -backend-config="encrypt=true"'
      }
    }
    stage ('terraform plan'){
      steps {
        sh "aws --version"
        sh "aws s3 ls"
        sh 'cd terraform/aws-rds; \
        terraform plan | landscape '
      }
    }
  }
}
