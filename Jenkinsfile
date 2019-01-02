pipeline {
  agent any
  environment {
    GIT_COMMIT_AUTHOR = sh (script: "git show -s --pretty=%an",returnStdout: true).trim()
    GIT_COMMIT_SHORT_SHA = sh (script: "echo $GIT_COMMIT | cut -c1-7",returnStdout: true).trim()
    AWS_ACCESS_KEY_ID = credentials('terra-access-key');
    AWS_SECRET_ACCESS_KEY = credentials('terra-secret-access-key');
    AWS_DEFAULT_REGION = 'eu-central-1'
    SLACK_TOKEN = credentials('slack_tocken');
    SLACK_TEAM_DOMAIN = credentials('slack_team_domain');
    TF_S3_STATE_BUCKET = 'tf-state-file-myjenkins'
    TF_S3_STATE_BUCKET_KEY = 'dokcer-ecs'
    TF_PLAN_NAME = "${env.GIT_COMMIT_AUTHOR}-${env.GIT_COMMIT_SHORT_SHA}.plan"
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
      environment {
        TF_LANDSCAPE_PLAN = sh (returnStdout: true, script: "cd terraform/aws-rds && terraform plan -out ${env.TF_PLAN_NAME} -input=false -detailed-exitcode | landscape").trim()
      }
      steps {
        sh "cd terraform/aws-rds && terraform plan -out ${env.TF_PLAN_NAME} -input=false -detailed-exitcode | landscape"
        stash name: "terraform-plan", includes: "terraform/aws-rds/${env.TF_PLAN_NAME}"
        // sh 'env'
      }
    }
    stage ('terraform apply'){
      steps {
        script {
          stage ('slack-notify') {
            slackSend (color: 'good', message: "A new terraform plan was generated (<${env.RUN_DISPLAY_URL}|here>): ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
          }
          stage ('user-prompt'){
            script {
              try {
                input message: "Apply plan?", ok: 'Apply', parameters: [
                  [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'some description', name: 'Please confirm you agree with this'],
                  [$class: 'TextParameterDefinition', defaultValue: 'a text\nwith several lines', description: 'A multiple lines text', name: 'aText']
                  ]
                // input message: "Apply plan?", ok: 'Apply', parameters [
                //   [$class: 'TextParameterDefinition', defaultValue: 'a text\nwith several lines', description: 'A multiple lines text', name: 'aText']
                // ]
                apply = true
              } catch (err) {
                apply = false
                currentBuild.result = 'UNSTABLE'
              }
            }
          }
          stage ('terraform-apply'){
            script {
              unstash 'terraform-plan'
              if (apply) {
                if (fileExists("apply.status")) {
                    sh "rm apply.status"
                }
                sh 'set +e; terraform apply terraform/aws-rds/$TF_PLAN_NAME; echo \$? > apply.status'
                def applyExitCode = readFile('apply.status').trim()
                if (applyExitCode == "0") {
                    slackSend (color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                } else {
                    slackSend (color: 'danger', message: "Terraform apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                    currentBuild.result = 'FAILURE'
                }
              }
              else {
                slackSend (color: 'warning', message: "Terraform plan discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                unstash 'terraform-plan'
                sh 'rm terraform/aws-rds/$TF_PLAN_NAME'
              }
            }
          }
        }
      }
    }
  }
}
