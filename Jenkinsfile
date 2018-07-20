node {
    stage('scm'){
        git url: 'git@github.com:ranimufid/dokcer-ecs.git'
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
