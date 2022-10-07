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

                    container('podman') {
                        sh """
                            podman system prune -a -f
                            echo "CLEANUP DONE"
                            podman pull alpine:latest
                            echo "PULL DONE"
                            mkdir -p scap
                            export IMG_ID=$(podman images -q alpine:latest)
                            echo $IMG_ID
                            echo $(podman images)
                            echo "vulnerability.html" >  ./scap/vulnerability.html
                            oscap-podman $IMG_ID oval eval --report vulnerability.html rhel-8.oval.xml
                        """
                    }

                }

            }

        }


        steps {
             sh """
                 echo py2Ana=$py2Ana
                 py2Ana=Initialized
                 echo py2Ana Initialized=$py2Ana
             """
         }

        stage ('Generate vulnerability report') {

            steps {

                dir("source") {
                    publishHTML([allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: 'scap',
                                reportFiles: 'vulnerability.html',
                                reportName: 'OpenSCAP vulnerability Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true])

                }

            }

        }

    }



}
