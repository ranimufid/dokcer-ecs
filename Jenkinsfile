pipeline {
  agent any
  environment {
    AWS_ACCESS_KEY_ID = credentials('terra-access-key');
    AWS_SECRET_ACCESS_KEY = credentials('terra-secret-access-key');
    AWS_DEFAULT_REGION = 'eu-central-1'
    TF_S3_STATE_BUCKET = 'tf-state-file-myjenkins'
    TF_S3_STATE_BUCKET_KEY = 'dokcer-ecs'
    SLACK_TOKEN = credentials('slack_tocken');
    SLACK_TEAM_DOMAIN = 'semperfi-ranit';
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
        // sh 'cd terraform/aws-rds && terraform plan -out $(echo $GIT_COMMIT | cut -c1-7)-$(git show -s --pretty=%an).plan -input=false -detailed-exitcode | landscape | tee landscape-plan.txt'
        sh 'env'
        script {
          TF_LANDSCAPE_PLAN= sh (returnStdout: true, script: '''cd terraform/aws-rds && terraform plan -out $(echo $GIT_COMMIT | cut -c1-7)-$(git show -s --pretty=%an).plan -input=false -detailed-exitcode | landscape''')
          // sh "echo ${env.TF_LANDSCAPE_PLAN}"
        }
        // sh "echo ${env.TF_LANDSCAPE_PLAN}"
      }
    }
    stage ('slack'){
      steps {
        echo "${TF_LANDSCAPE_PLAN}"
        slackSend (color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ```${TF_LANDSCAPE_PLAN}```", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
        script {
          try {
            input message: 'Apply Plan?', ok: 'Apply'
            apply = true
          } catch (err) {
              slackSend (color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
              apply = false
              currentBuild.result = 'UNSTABLE'
          }
        }
      }
    }
  }
}
