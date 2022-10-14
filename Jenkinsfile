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
                        sh '''
                            podman system prune -a -f
                            echo "CLEANUP DONE"
                            podman pull alpine:latest
                            echo "PULL DONE"
                            mkdir -p scap
                            export IMG_ID=$(podman images -q alpine:latest)
                            wget -O - https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2 | bzip2 --decompress > ./rhel-8.oval.xml
                            #wget https://www.redhat.com/security/data/metrics/com.redhat.rhsa-all.xccdf.xml > ./com.redhat.rhsa-all.xccdf.xml
                            #wget https://www.redhat.com/security/data/oval/com.redhat.rhsa-all.xml > ./com.redhat.rhsa-all.xml

                            oscap-podman $IMG_ID xccdf eval --report hipaa.html --profile hipaa /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml
                            oscap-podman $IMG_ID xccdf eval --report ospp.html --profile ospp /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml
                            oscap-podman $IMG_ID xccdf eval --report pci-dss.html --profile pci-dss /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml

                            oscap-podman $IMG_ID oval eval --report ./scap/oval.html ./rhel-8.oval.xml
                        '''
                    }

                }

            }

        }

        stage ('Generate vulnerability report') {

            steps {

                dir("source") {
                    publishHTML([allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: 'scap',
                                reportFiles: 'hipaa.html',
                                reportName: 'OpenSCAP hipaa Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true])

                    publishHTML([allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: 'scap',
                                reportFiles: 'ospp.html',
                                reportName: 'OpenSCAP ospp Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true])

                    publishHTML([allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: 'scap',
                                reportFiles: 'pci-dss.html',
                                reportName: 'OpenSCAP pci-dss Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true])

                    publishHTML([allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: 'scap',
                                reportFiles: 'oval.html',
                                reportName: 'OpenSCAP oval Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true])

                }

            }

        }

    }



}
