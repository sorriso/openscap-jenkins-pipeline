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
                  volumeMounts:
                  - name: var-run
                    mountPath: /var/run
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

        stage('Clean up docker workspace') {

            steps {

                container('docker') {

                    sh('docker system prune -a -f')
                    sh('echo "CLEANUP DONE" ')

                }

            }

            steps {

                container('docker') {

                    sh('docker pull alpine:latest')
                    sh('echo "PULL DONE" ')

                }

            }

        }

    }



}
