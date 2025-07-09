pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'
        CONTAINER_NAME = 'airflow_container'
        POSTGRES_CONTAINER_NAME = 'postgres_container'
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = '169.63.102.13'
        DEPLOY_SERVER = "${DEPLOY_USER}@${DEPLOY_HOST}"
        REMOTE_HOME = '/home/ubuntu'
        AIRFLOW_IMAGE = 'airflow-image'
        POSTGRES_IMAGE = 'postgres-image'
        AIRFLOW_IMAGE_FILE = 'airflow-image.tar'
        POSTGRES_IMAGE_FILE = 'postgres-image.tar'
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

        stage('Build Images') {
            steps {
                sh "docker build -t ${AIRFLOW_IMAGE} ./airflow"
                sh "docker build -t ${POSTGRES_IMAGE} ./postgres"
            }
        }

        stage('Transfer Files to Remote Server') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        docker save ${AIRFLOW_IMAGE} -o ${AIRFLOW_IMAGE_FILE}
                        docker save ${POSTGRES_IMAGE} -o ${POSTGRES_IMAGE_FILE}
                        chmod 600 \$SSH_KEY
                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no ${AIRFLOW_IMAGE_FILE} ${DEPLOY_SERVER}:${REMOTE_HOME}/
                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no ${POSTGRES_IMAGE_FILE} ${DEPLOY_SERVER}:${REMOTE_HOME}/
                        scp -i \$SSH_KEY -o StrictHostKeyChecking=no ${LOCAL_ENV_PATH} ${DEPLOY_SERVER}:${REMOTE_HOME}/
                    """
                }
            }
        }

        stage('Deploy Postgres and Airflow') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                            docker load -i ${POSTGRES_IMAGE_FILE}
                            docker load -i ${AIRFLOW_IMAGE_FILE}

                            docker rm -f ${POSTGRES_CONTAINER_NAME} || true
                            docker run -d --name ${POSTGRES_CONTAINER_NAME} -p 5432:5432 --env-file ${ENV_FILE} ${POSTGRES_IMAGE}

                            echo "Aguardando Postgres iniciar..."
                            for i in {1..10}; do
                                docker exec ${POSTGRES_CONTAINER_NAME} pg_isready -U \$POSTGRES_USER && break
                                echo "Esperando Postgres ficar pronto... (\$i)"
                                sleep 5
                            done

                            docker rm -f ${CONTAINER_NAME} || true
                            docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --env-file ${ENV_FILE} ${AIRFLOW_IMAGE} standalone
                        '
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDENTIAL_ID}", keyFileVariable: 'SSH_KEY')]) {
                    sh """
                        ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                            echo "Verificando containers ativos:"
                            docker ps | grep -E "${CONTAINER_NAME}|${POSTGRES_CONTAINER_NAME}" || true

                            echo "Verificando status do Postgres:"
                            docker exec ${POSTGRES_CONTAINER_NAME} pg_isready -U \$POSTGRES_USER || true
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
