node('master') {
    parameters([
            string(name: 'DEPLOYEMENT_TARGET', defaultValue: '', description: 'Hostname or IP of the target host')
        ])
    withCredentials([sshUserPrivateKey(credentialsId: 'Jenkins_deployer', keyFileVariable: 'keyfile', passphraseVariable: '', usernameVariable: '')]) {
        def remote = [:]
        remote.name = 'EQS k8s'
        remote.host = "${DEPLOYMENT_TARGET}"
        remote.user = 'deployer'
        remote.identityFile = keyfile
        remote.allowAnyHosts = true
        remote.pty = true
    
        
        /*stage('Install K8S') { */
            /*sshCommand remote: remote, command: "snap install microk8s --classic"*/
        /*}*/

        stage('Install K8S') { 
            sshCommand remote: remote, command: "sudo ls -l /"
        }
    }
}
