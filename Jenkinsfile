pipeline {
    agent any

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'
        CONTAINER_NAME = "airflow-${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/LuizNazareth10/PrimeUpJenkinsAutomatizationTest.git', branch: 'main'
            }
        }

        stage('Build Services') {
            steps {
                sh 'docker build -t airflow-image ./airflow'
            }
        }

        stage('Remove Old Container') {
            steps {
                sh "docker rm -f ${CONTAINER_NAME} || true"
            }
        }

        stage('Start Container (Only Airflow)') {
            steps {
                sh "docker run -d --name ${CONTAINER_NAME} -p 8080:8080 --env-file .env airflow-image"
            }
        }

        stage('Check Airflow Status') {
            steps {
                sh "docker ps | grep ${CONTAINER_NAME} || true"
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
