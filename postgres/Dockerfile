FROM postgres:latest

# Copia o script de inicialização se necessário
COPY init.sql /docker-entrypoint-initdb.d/

# Define variáveis padrão (podem ser sobrescritas por --env-file)
ENV POSTGRES_USER=airflow
ENV POSTGRES_PASSWORD=airflow
ENV POSTGRES_DB=airflow

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=5 CMD pg_isready -U $POSTGRES_USER
