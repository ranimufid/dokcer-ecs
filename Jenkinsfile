pipeline {
  agent any
  environment {
    AWS_ACCESS_KEY_ID = credentials('terra-access-key');
    AWS_SECRET_ACCESS_KEY = credentials('terra-secret-access-key');
    AWS_DEFAULT_REGION = 'eu-central-1'
    SLACK_TOKEN = credentials('slack_tocken');
    SLACK_TEAM_DOMAIN = credentials('slack_team_domain');
    TF_S3_STATE_BUCKET = 'tf-state-file-myjenkins'
    TF_S3_STATE_BUCKET_KEY = 'dokcer-ecs'
    TF_PLAN_NAME = sh(returnStdout: true, script: "$(echo $GIT_COMMIT | cut -c1-7)-$(git show -s --pretty=%an).plan")
  }
  stages {
    stage ('clean') {
      steps {
        sh 'env'
        script {
          if (fileExists(".terraform/terraform.tfstate")) {
            sh "rm -rf .terraform/terraform.tfstate"
          }
        }
        sh "terraform --version"
      }
    }
    stage('terraform fmt') {
      steps {
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
          -backend-config="encrypt=true" && \
          terraform get --update'
      }
    }
    stage ('terraform plan'){
      steps {
        sh 'cd terraform/aws-rds && terraform plan -out $(echo $GIT_COMMIT | cut -c1-7)-$(git show -s --pretty=%an).plan -input=false -detailed-exitcode | landscape'
        // stash includes:
      }
    }
    stage ('terraform apply'){
      steps {
        slackSend (color: 'good', message: "A new terraform plan was generated (<${env.RUN_DISPLAY_URL}|here>): ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
        script {
          stage ('slack-prompt'){
            script {
              try {
                input message: 'Apply Plan?', ok: 'Apply'
                apply = true
              } catch (err) {
                slackSend (color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                apply = false
                currentBuild.result = 'UNSTABLE'
              }
            }
          }
          stage ('apply'){
            script {
              if (apply) {
                sh 'env'
              }
            }
          }
        }
      }
    }
    // stage ('apply'){
    //   steps {
    //     script {

    //     }
    //   }
    // }
  }
}
