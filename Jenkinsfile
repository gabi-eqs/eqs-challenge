node('master') {
    properties([
        parameters([
            string(name: 'DEPLOYMENT_TARGET', defaultValue: '1.1.1.1', description: 'Hostname or IP of the target host')
        ])
    ])
    

    stage('Clone repo') {
        git url: 'https://github.com/vault60/eqs-challenge.git'
    }
    
    
    
    withCredentials([sshUserPrivateKey(credentialsId: 'Jenkins_deployer', keyFileVariable: 'keyfile', passphraseVariable: '', usernameVariable: '')]) {
        def remote = [:]
        remote.name = 'EQS k8s'
        remote.host = "${DEPLOYMENT_TARGET}"
        remote.user = 'deployer'
        remote.identityFile = keyfile
        remote.allowAnyHosts = true
        remote.pty = true
    
        
        stage('Install K8S') { 
            sh 'ls -la $WORKSPACE'
            sshCommand remote: remote, sudo:true, command: "snap install microk8s --classic"
            sshCommand remote: remote, sudo:true, command: "usermod -a -G microk8s deployer"
        }

        stage('Modify config') { 
            sshCommand remote: remote, sudo:true, command: "sed -i 's/#MOREIPS/#MOREIPS\\nIP.5 = ${DEPLOYMENT_TARGET}/' /var/snap/microk8s/current/certs/csr.conf.template"
        }
        
        stage('Set up access') {
            dir("/home/deployer") {
                sshCommand remote: remote, sudo:false, command: "mkdir -p .kube && microk8s config > .kube/config" 
            }
            sshPut remote: remote, from: "${WORKSPACE}/deployment/namespace.yaml", into: '/tmp/'
            sshPut remote: remote, from: "${WORKSPACE}/deployment/access.yaml", into: '/tmp/'
            sshCommand remote: remote, sudo:false, command: "microk8s.kubectl apply -f /tmp/namespace.yaml -f /tmp/access.yaml"
            def token_name = sshCommand remote: remote, sudo:true, command: "microk8s.kubectl get sa deployer -n production -o 'jsonpath={.secrets[0].name}'"
            def token = sshCommand remote: remote, sudo:true, command: "microk8s.kubectl get secret ${token_name} -n production -o \"jsonpath={.data.token}\" | base64 -d"  
            def cert = sshCommand remote: remote, sudo:true, command: "microk8s.kubectl get secret ${token_name} -n production -o \"jsonpath={.data['ca\\.crt']}\""
            def data = readFile(file: 'kube_config')
            template = data.replaceAll("##TOKEN##", "${token}")
                           .replaceAll("##CERT##", "${cert}")
                           .replaceAll("##IP_ADDRESS##", "${DEPLOYMENT_TARGET}")
            writeFile(file: 'config', text: template)
        }
        
        stage('Publish config') {
            archiveArtifacts('config')
        }
    }
}

