node {
    stage('scm'){
        git url: 'git@github.com:ranimufid/dokcer-ecs.git'
    }
    stage ('install terraform'){
        def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
        env.PATH = "${tfHome}:${env.PATH}"
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

// Functions
def downloadTerraform(){
  if (!fileExists('terraform')) {
    sh "curl -o  terraform_0.11.7_linux_amd64.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && unzip -o terraform_0.11.7_linux_amd64.zip && chmod 777 terraform"
  } else {
    println("terraform already installed")
  }
}