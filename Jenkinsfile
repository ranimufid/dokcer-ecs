node {
    stage('scm'){
        git url: 'git@github.com:ranimufid/dokcer-ecs.git'
    }
    stage ('slack'){
        slackSend color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
    }
}
