-- Cria o banco de dados airflow
CREATE DATABASE airflow;

-- Conecta ao banco airflow
\connect airflow;

-- Cria o usuário airflow com senha
CREATE USER airflow WITH PASSWORD 'airflow';

-- Concede permissões ao usuário
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;

-- Permite criação de tabelas no esquema padrão
ALTER SCHEMA public OWNER TO airflow;
