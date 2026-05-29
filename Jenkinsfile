pipeline {
    agent any

    stages {
        stage('Clean-up') {
            steps {
                sh '''
                    docker rm -f flask-app || true
                    docker rm -f nginx-proxy || true
                '''
            }
        }

        stage('Set-up Network') {
            steps {
                sh '''
                    docker network create app-network || true
                '''
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    docker build -t flaskapp -f Dockerfile .
                    docker build -t nginx-proxy -f Dockerfile.nginx .
                '''
            }
        }

        stage('Run Containers') {
            steps {
                sh '''
                    docker run -d --name flask-app --network app-network flaskapp

                    docker run -d --name nginx-proxy --network app-network -p 80:80 nginx-proxy
                '''
            }
        }
    }
}