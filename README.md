# eqs-challenge

The test task solutions consists of two part: setting up a Jenkins instance and creating pipelines for deploying a single-node Kubernetes cluster with a very basic nginx-hosted website.

1. The Jenkins instance is run as a Docker container, according to the assignement requirements. For this a custom image has been created that has the Helm binary integrated. The corresponding Dockerfile can be found [here](Dockerfile). To run a new instance, the next command can be used:
```
docker run --rm -d -p 80:8080 -p 50000:50000 -u 1001 -v /var/lib/jenkins:/var/jenkins_home --name jenkins ghcr.io/vault60/eqs-challenge/jenkins-helm
```

For preserving the configs, job history and other information the container shares the Jenkins home folder with the host. The image used for running Jenkins was uploaded to the Github Docker registry: ghcr.io/vault60/eqs-challenge/jenkins-helm:latest. A number of plugins, extending the list of Jenkins features, has also been installed: SSH Pipeline Steps, Config File Provider etc. This step can be automated even more as described [here](https://github.com/jenkinsci/docker#usage-1), but it would take having a list of features one might need and the required plugins with their dependencies beforehand.


2. A single-node K8S cluster and an Nginx website are deployed by two separate Jenkins pipelines, which are defined in [this](Jenkinsfile) and [this](Jenkinsfile) files accordingly. The first pipeline receives one parameter: an IP address or a host name of a target host. The job prepares a new cluster and creates a kube config, that can be used for connecting the newly created cluter. The config is generated from a template and after the job ends, it may be stored in Jenkins as one of managed files. A web-site, which is set up by the second pipeline, is deployed to a separate ("production") namespace. The nginx configuration is stored in form of a ConfigMap, which is generated by the Helm templating engine. This deployment can be triggered by a change made in this repo, which in turn is triggered by the 'post-recieve' Git hook.

There still are quite a few things that could be improved in scope of this task:
* creating DNS-records for the hosts
* enabling TLS encryption for Jenkins and nginx
* setting up a load balancer service instead of the NodePort
