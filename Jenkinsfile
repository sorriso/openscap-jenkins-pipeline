#!groovy

pipeline {

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
