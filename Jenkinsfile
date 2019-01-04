pipeline {
  agent any
  options {
    ansiColor colorMapName: 'XTerm'
  }
  environment {
    GIT_COMMIT_AUTHOR = sh (script: "git show -s --pretty=%an",returnStdout: true).trim()
    GIT_COMMIT_SHORT_SHA = sh (script: "echo $GIT_COMMIT | cut -c1-7",returnStdout: true).trim()
    AWS_ACCESS_KEY_ID = credentials('terra-access-key');
    AWS_SECRET_ACCESS_KEY = credentials('terra-secret-access-key');
    SLACK_TOKEN = credentials('slack_tocken');
    SLACK_TEAM_DOMAIN = credentials('slack_team_domain');
    TF_PLAN_NAME = "${env.GIT_COMMIT_AUTHOR}-${env.GIT_COMMIT_SHORT_SHA}.plan"
  }
  stages {
    stage('terraform fmt') {
      steps {
        sh "cd terraform/aws-rds/ && terraform fmt -check=true -diff=true"
      }
    }
    stage ('terraform init'){
      steps {
        sh 'cd terraform/aws-rds && \
        terraform --version && \
        terraform init && \
        terraform get --update'
      }
    }
    stage ('terraform plan'){
      steps {
        sh "cd terraform/aws-rds && terraform plan -out ${env.TF_PLAN_NAME} -input=false -detailed-exitcode | landscape"
        stash name: "terraform-plan", includes: "terraform/aws-rds/${env.TF_PLAN_NAME}"
        script {
          env.TF_LANDSCAPE_PLAN = sh (returnStdout: true, script: "cd terraform/aws-rds && terraform plan -out ${env.TF_PLAN_NAME} -input=false -detailed-exitcode | landscape --no-color").trim()
        }
      }
    }
    stage ('terraform apply'){
      when {
        not {
          environment name: 'TF_LANDSCAPE_PLAN', value: 'No changes.'
        }
      }
      steps {
        script {
          stage ('slack-notify') {
            slackSend (color: 'good', message: "A new terraform plan was generated (<${env.RUN_DISPLAY_URL}|here>): ${env.JOB_NAME} - ${env.BUILD_NUMBER}", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
          }
          stage ('user-prompt'){
            script {
              try {
                input message: "Apply plan?", ok: 'Apply', parameters: [[$class: 'TextParameterDefinition', defaultValue: "$TF_LANDSCAPE_PLAN", description: 'Terraform would like to apply the following changes', name: 'aText']]
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
                sh 'set +e; cd terraform/aws-rds && terraform apply $TF_PLAN_NAME; echo \$? > apply.status'
                applyExitCode = readFile('terraform/aws-rds/apply.status').trim()
                if (applyExitCode == "0") {
                    slackSend (color: 'good', message: "Terraform changes applied ${env.JOB_NAME} - <${env.RUN_DISPLAY_URL}|${env.BUILD_NUMBER}>", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                } else {
                    slackSend (color: 'danger', message: "Terraform apply failed: ${env.JOB_NAME} - <${env.RUN_DISPLAY_URL}|${env.BUILD_NUMBER}>", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                    currentBuild.result = 'FAILURE'
                }
              }
              else {
                slackSend (color: 'warning', message: "Terraform plan discarded: ${env.JOB_NAME} - <${env.RUN_DISPLAY_URL}|${env.BUILD_NUMBER}>", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}")
                unstash 'terraform-plan'
                sh 'rm terraform/aws-rds/$TF_PLAN_NAME'
              }
            }
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
