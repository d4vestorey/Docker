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

        stage("Run unit tests") {
            steps {
                script {
                        catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                            sh """
                                python3 -m venv .venv
                                . .venv/bin/activate
                                pip install -r requirements.txt
                                python3 -m unittest -v test_app.py
                                deactivate
                            """
                            }
                        }
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

        stage('Trivy Scan') {
            steps {
                sh '''
                    trivy image -f json -o flaskapp-results.json flaskapp
                    trivy image -f json -o nginx-results.json nginx-proxy

                    cat flaskapp-results.json
                    cat nginx-results.json
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

    post {
            always {
                archiveArtifacts artifacts: '*-results.json', onlyIfSuccessful: true
            }
        }
}