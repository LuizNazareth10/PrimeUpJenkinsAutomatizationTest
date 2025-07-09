#!/bin/bash

airflow db migrate
airflow users create \
    --username airflow \
    --firstname Admin \
    --lastname PrimeUp \
    --role Admin \
    --email airflow@primeup.com.br \
    --password primeup

exec airflow standalone

# a ideia desse entrypoint é garantir que o banco de dados esteja migrado e que o usuário admin seja criado antes de iniciar o Airflow.
#Jenkins não passa a informação de usuário e senha do Airflow, então o entrypoint.sh é usado para criar um usuário admin padrão.
# Pode ser alterado se necessário.