pipeline {
    agent {
        label 'docker'
    }

    environment {
        COMPOSE_PROJECT_NAME = 'airflow_simulation'    
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/LuizNazareth10/PrimeUpJenkinsAutomatizationTest.git', branch: 'main'
            }
        }

        stage('Build Services') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Start Containers') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Check Airflow Status') {
            steps {
                sh 'docker ps | grep airflow || true'
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
