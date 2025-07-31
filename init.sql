-- Script de inicialização para o Postgres: cria a tabela tb_customers se não existir
CREATE TABLE IF NOT EXISTS tb_customers (
  id VARCHAR PRIMARY KEY,
  username VARCHAR NOT NULL UNIQUE,
  password VARCHAR NOT NULL,
  role VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);


-- Criação da tabela tb_policies
CREATE TABLE IF NOT EXISTS tb_policies (
  id UUID PRIMARY KEY,
  policy_number VARCHAR(12) NOT NULL,
  tb_customer_id VARCHAR NOT NULL REFERENCES tb_customers(id),
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  status VARCHAR,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

INSERT INTO tb_customers (id, username, password, role, created_at, updated_at)
VALUES ('04636075030',
        'juniomenchik',
        '11112000',
        'Admin',
        '2025-07-30 16:31:58.465026',
        '2025-07-30 16:31:58.465026');

INSERT INTO tb_customers (id, username, password, role, created_at, updated_at)
VALUES ('00011122233',
        'operador',
        'operador123',
        'Operador',
        '2025-07-30 16:31:58.465026',
        '2025-07-30 16:31:58.465026');

INSERT INTO tb_customers (id, username, password, role, created_at, updated_at)
VALUES ('15975312355',
        'cliente',
        'cliente123',
        'Cliente',
        '2025-07-30 16:31:58.465026',
        '2025-07-30 16:31:58.465026');


INSERT INTO tb_policies (id, policy_number, tb_customer_id, start_date, end_date, status, created_at, updated_at)
VALUES (
           '00011122233',
  'POL123456789',
  '04636075030',
  '2025-08-01 00:00:00',
  '2026-08-01 00:00:00',
  'Ativa',
  '2025-07-30 16:31:58.465026',
  '2025-07-30 16:31:58.465026'
);