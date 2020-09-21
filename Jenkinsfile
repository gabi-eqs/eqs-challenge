node('master') {
    withCredentials([sshUserPrivateKey(credentialsId: 'Jenkins_deployer', keyFileVariable: 'keyfile', passphraseVariable: '', usernameVariable: '')]) {
        def remote = [:]
        remote.name = 'EQS k8s'
        remote.host = '34.216.200.137'
        remote.user = 'deployer'
        remote.identityFile = keyfile
        remote.allowAnyHosts = true
        remote.pty = true
    
        stage('test') {
            sshCommand remote: remote, command: "ls -lh /"
        }
    }
}
