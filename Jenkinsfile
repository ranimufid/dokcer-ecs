node {
    environment {
        TF_S3_STATE_BUCKET = "tf-state-file-myjenkins"
        TF_S3_STATE_BUCKET_KEY = 'dokcer-ecs'
    }

    // stages {
        stage('scm'){
            // steps {
                git url: 'git@github.com:ranimufid/dokcer-ecs.git'
            // }
        }
        stage ('install terraform'){
            // steps {
                def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
                env.PATH = "${tfHome}:${env.PATH}"
                sh "terraform --version"
            // }
        }
        stage ('terraform setup'){
            // steps {
                sh 'echo $TF_S3_STATE_BUCKET_KEY'
                sh 'terraform remote config \
                -backend=s3 \
                -backend-config="bucket=${TF_S3_STATE_BUCKET}" \
                -backend-config="key=${TF_S3_STATE_BUCKET_KEY}/terraform.tfstate" \
                -backend-config="region=eu-central-1" \
                -backend-config="acl=bucket-owner-full-control"'
            // }
        }
        stage ('slack'){
            steps {
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
    // }
}

// Functions
// def terraform_init(){
// }

// def initialize_remote_state() {
//   // stage 'initialize remote state'
//   withEnv(["S3_BUCKET=$TF_S3_STATE_BUCKET","S3_KEY=$TF_S3_STATE_BUCKET_KEY"]) {
//     _sh '''\
//       terraform remote config \
//         -backend=s3 \
//         -backend-config="bucket=${S3_BUCKET}" \
//         -backend-config="key=${S3_KEY}/terraform.tfstate" \
//         -backend-config="region=eu-central-1" \
//         -backend-config="acl=bucket-owner-full-control"
//     '''.stripIndent()
//   }
// }