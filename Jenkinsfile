node {
    stage('checkout'){
        git url: 'git@github.com:ranimufid/dokcer-ecs.git'
    }
    stage ('install terraform'){
        def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
        env.PATH = "${tfHome}:${env.PATH}"
        sh "terraform --version"
    }
    stage ('terraform plan'){
        //  withEnv(["TF_S3_STATE_BUCKET=tf-state-file-myjenkins", "TF_S3_STATE_BUCKET_KEY=dokcer-ecs"]) {
        //     sh 'cd terraform/aws-rds; \
        //         terraform init \
        //           -backend-config="bucket=$TF_S3_STATE_BUCKET" \
        //           -backend-config="key=$TF_S3_STATE_BUCKET_KEY/terraform.tfstate" \
        //           -backend-config="region=eu-central-1" \
        //           -backend-config="private=private" \
        //           -backend-config="encrypt=true"'
        // }
        withCredentials([[
            $class: "AmazonWebServicesCredentialsBinding",
            credentialsId: "rds-s3-access",
            accessKeyVariable: "AWS_ACCESS_KEY_ID",
            secretKeyVariable: "AWS_SECRET_ACCESS_KEY"]]) {
            sh  "aws --version"
            sh "aws s3 ls"
          }
    }
    stage ('checking out all repos'){
        parallel {
            "task 1": {
                sh "terraform --version"
            }
            "task 2": {
                sh "terraform --version"
            }
            "task 3": {
                sh "terraform --version"
            }
        }
      }
    }
    stage ('slack'){
        slackSend color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
        try {
            input message: 'Apply Plan?', ok: 'Apply'
            apply = true
        } catch (err) {
            slackSend color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
            apply = false
            currentBuild.result = 'UNSTABLE'
        }
    }
}
