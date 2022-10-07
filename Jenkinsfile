#!groovy

pipeline {

    agent {

        kubernetes {

          yaml '''
              apiVersion: v1
              kind: Pod
              metadata:
                namespace: devops
                metadata:
                  labels:
                    agent: kube
              spec:
                containers:
                - name: docker
                  image: l_docker:dind
                  imagePullPolicy: IfNotPresent
                  resources:
                    limits:
                      cpu: 500m
                      memory: 3Gi
                    requests:
                      cpu: 10m
                      memory: 256Mi
                  securityContext:
                    privileged: true
                - name: podman
                  image: l_docker:scap
                  imagePullPolicy: IfNotPresent
                  resources:
                    limits:
                      cpu: 500m
                      memory: 3Gi
                    requests:
                      cpu: 10m
                      memory: 256Mi
                  securityContext:
                    privileged: true
                volumes:
                - name: var-run
                  emptyDir: {}
            '''

        }

    }

    options {

        // Only keep the 5 most recent builds
        buildDiscarder(logRotator(numToKeepStr:'2'))

    }

    stages {

        stage('Build') {

            steps {

                dir("source") {

                    container('docker') {

                        sh('docker system prune -a -f')
                        sh('echo "CLEANUP DONE" ')
                        sh('docker pull alpine:latest')
                        sh('echo "PULL DONE" ')
                        sh('mkdir -p scap ')
                        sh('echo "vulnerability.html" >  ./scap/vulnerability.html')
                        sh('echo "CURRENT PATH" ')
                        sh('echo $(pwd) ')
                        sh('echo "LS" ')
                        sh('echo $(ls -al) ')

                    }

                }

            }

        }

        stage ('Generate vulnerability report') {

            steps {

                dir("source") {

                  publishHTML([allowMissing: false,
                  alwaysLinkToLastBuild: false,
                  keepAll: true,
                  reportDir: 'scap',
                  reportFiles: 'vulnerability.html',
                  reportName: 'vulnerability')

                }

            }

        }

    }



}
