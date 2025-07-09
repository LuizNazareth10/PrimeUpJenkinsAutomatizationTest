FROM apache/airflow:2.9.1-python3.10

COPY requirements.txt /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]