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
