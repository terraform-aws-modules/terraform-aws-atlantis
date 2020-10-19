#!/usr/bin/env groovy

pipeline {
    agent {
        label 'fastlane'
    }
    stages {
        stage('Build Dockerfile'){
            steps {
                withCredentials([file(credentialsId: 'atlantis-github-app-key-file', variable: 'FILE')]) {
                    script {
                        def DOCKER_REGISTRY = 'https://008963853103.dkr.ecr.us-east-1.amazonaws.com'
                        docker.withRegistry(DOCKER_REGISTRY) {
                            withAWS(credentials: 'devAWSCredentials') {
                                def dockerImageName = "atlantis"
                                def dockerfilePath = "./Dockerfile"
                                def dockerImageVersion = sha1(dockerfilePath)
                                def dockerImageExists = sh(script: "aws ecr describe-images --repository-name ${dockerImageName} --image-ids imageTag=${dockerImageVersion}", returnStatus: true) == 0
                                if (!dockerImageExists) {
				    def keyFileCopy = "atlantis-github-app-key-file.pem"
                                    sh "cp ${FILE} ${keyFileCopy}"
                                    dockerImage = docker.build(dockerImageName, "--build-arg SECRET_KEY_FILE=${keyFileCopy} .")
                                    dockerImage.push(dockerImageVersion)
                                    dockerImage.push("latest")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}