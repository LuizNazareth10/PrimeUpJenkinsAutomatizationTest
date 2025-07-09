FROM apache/airflow:2.9.1-python3.10

COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER airflow

ENTRYPOINT ["/entrypoint.sh"]
