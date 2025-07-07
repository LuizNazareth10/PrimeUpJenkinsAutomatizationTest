pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'
        CONTAINER_NAME = 'airflow_container'
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = '169.63.102.13'
        DEPLOY_SERVER = "${DEPLOY_USER}@${DEPLOY_HOST}"
        REMOTE_HOME = '/home/ubuntu'
        IMAGE_NAME = 'airflow-image'
        IMAGE_FILE = 'airflow-image.tar'
        SSH_CREDENTIAL_ID = 'bizbook-rsa-key'
        ENV_FILE = '.env'
        LOCAL_ENV_PATH = './.env'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/LuizNazareth10/PrimeUpJenkinsAutomatizationTest.git', branch: 'main'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ./airflow"
            }
        }

        stage('Transfer Files to Remote Server') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        docker save ${IMAGE_NAME} -o ${IMAGE_FILE}
                        chmod 600 \$SSH_KEY
                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no ${IMAGE_FILE} ${DEPLOY_SERVER}:${REMOTE_HOME}/
                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no ${LOCAL_ENV_PATH} ${DEPLOY_SERVER}:${REMOTE_HOME}/
                    """
                }
            }
        }

        stage('Deploy on Remote Server') {
            steps { // Using the SSH key to connect and deploy the Docker container, carrega a imagem .tar para o servidor remoto de deploy, remove um container antigo se existir, e inicia um novo container com a imagem carregada
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                            docker load -i ${IMAGE_FILE} && 
                            docker rm -f ${CONTAINER_NAME} || true &&
                            docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --env-file ${ENV_FILE} ${IMAGE_NAME} standalone
                        '
                    """
                }
            }
        }

        stage('Check Airflow Status') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                            docker ps | grep ${CONTAINER_NAME} || true
                        '
                    """
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
