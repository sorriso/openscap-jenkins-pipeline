#!groovy

pipeline {
    agent {

        kubernetes {
          yaml '''
              apiVersion: v1
              kind: Pod
              metadata:
                namespace: devops
              spec:
                containers:
                - image: l_docker:dind
                  name: docker
                  imagePullPolicy: IfNotPresent
                  name: docker
                  resources:
                    limits:
                      cpu: "1"
                      memory: 3Gi
                    requests:
                      cpu: 10m
                      memory: 256Mi
                  securityContext:
                    privileged: true
            '''
        }

    }

    options {

        // Only keep the 5 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'2'))

    }

    stages {

        container('docker') {

            stage('Clean up docker workspace') {

                steps {

                        sh('chmod +x /home/jenkins/agent/workspace/scap/*.sh')
                        sh('docker system prune -a -f')
                        sh('echo "CLEANUP DONE" ')

                }

            }

        }

    }



}
