node('master') {
    properties([
        parameters([
            string(name: 'DEPLOYMENT_TARGET', defaultValue: '34.216.200.137', description: 'Hostname or IP of the target host')
        ])
    ])
    withCredentials([sshUserPrivateKey(credentialsId: 'Jenkins_deployer', keyFileVariable: 'keyfile', passphraseVariable: '', usernameVariable: '')]) {
        def remote = [:]
        remote.name = 'EQS k8s'
        remote.host = "${DEPLOYMENT_TARGET}"
        remote.user = 'deployer'
        remote.identityFile = keyfile
        remote.allowAnyHosts = true
        remote.pty = true
    
        
        stage('Install K8S') { 
            sshCommand remote: remote, command: "sudo snap install microk8s --classic"
        }

        stage('Modify config') { 
            sshCommand remote: remote, command: "sudo sed -i 's/#MOREIPS/#MOREIPS\nIP.5 = ${DEPLOYMENT_TARGET}/' /var/snap/microk8s/current/certs/csr.conf.template"
        }
    }
}
