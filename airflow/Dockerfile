FROM apache/airflow:2.9.1-python3.10

COPY requirements.txt /requirements.txt

USER airflow  # <- troca antes da instalação porque gerou problema de uso do pip como ususario root

RUN pip install --no-cache-dir -r /requirements.txt
