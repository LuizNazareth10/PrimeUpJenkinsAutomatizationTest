pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'
        CONTAINER_NAME = 'airflow_container'
        DEPLOY_SERVER = 'ubuntu@169.63.102.13'
        SSH_CREDENTIAL_ID = 'bizbook-rsa-key'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/LuizNazareth10/PrimeUpJenkinsAutomatizationTest.git', branch: 'main'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t airflow-image ./airflow'
            }
        }

        stage('Transfer Files to Remote Server') {
            steps {
                sshagent (credentials: ["${SSH_CREDENTIAL_ID}"]) {
                    sh """
                        docker save airflow-image -o airflow-image.tar
                        scp airflow-image.tar ${DEPLOY_SERVER}:/home/ubuntu/
                        scp .env ${DEPLOY_SERVER}:/home/ubuntu/
                    """
                }
            }
        }

        stage('Deploy on Remote Server') {
            steps {
                sshagent (credentials: ["${SSH_CREDENTIAL_ID}"]) {
                    sh """
                        ssh ${DEPLOY_SERVER} '
                            docker load -i airflow-image.tar &&
                            docker rm -f ${CONTAINER_NAME} || true &&
                            docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --env-file .env airflow-image
                        '
                    """
                }
            }
        }

        stage('Check Airflow Status') {
            steps {
                sshagent (credentials: ["${SSH_CREDENTIAL_ID}"]) {
                    sh "ssh ${DEPLOY_SERVER} 'docker ps | grep ${CONTAINER_NAME} || true'"
                }
            }
        }
    }

    post {
        failure {
            echo "O deploy falhou. Verifique os logs para mais detalhes."
        }
        success {
            echo "Deploy realizado com sucesso!"
        }
    }
}
