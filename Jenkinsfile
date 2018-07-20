node {

    stages {
        scm {
            git url: 'git@github.com:ranimufid/dokcer-ecs.git'
        }
        slack {
            slackSend color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
        }
    }
}
