pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'
        CONTAINER_NAME = 'airflow_container'
        DEPLOY_SERVER = 'ubuntu@18.207.125.40'   // exemplo EC2
        PEM_FILE = '/var/jenkins_home/.ssh/jenkins-key.pem' // caminho dentro do container Jenkins
    }

    stages {
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
                sh """
                    docker save airflow-image -o airflow-image.tar
                    scp -i ${PEM_FILE} airflow-image.tar ${DEPLOY_SERVER}:/home/ubuntu/
                    scp -i ${PEM_FILE} .env ${DEPLOY_SERVER}:/home/ubuntu/
                """
            }
        }

        stage('Deploy on Remote Server') {
            steps {
                sh """
                    ssh -i ${PEM_FILE} ${DEPLOY_SERVER} '
                        docker load -i airflow-image.tar &&
                        docker rm -f ${CONTAINER_NAME} || true &&
                        docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --env-file .env airflow-image
                    '
                """
            }
        }

        stage('Check Airflow Status') {
            steps {
                sh """
                    ssh -i ${PEM_FILE} ${DEPLOY_SERVER} '
                        docker ps | grep ${CONTAINER_NAME} || true
                    '
                """
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
