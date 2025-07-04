FROM apache/airflow:2.9.1-python3.10

USER root

COPY requirements.txt /requirements.txt

# Instalação global, funciona com root
RUN pip install --no-cache-dir -r /requirements.txt

USER airflow
