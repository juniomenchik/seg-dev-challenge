# Desafio Segdev

Olá Jeferson, boa noite! Segue o desafio.

---

## 🧪 Desafio: Sistema de Apólices com Controle de Acesso

Implemente uma aplicação simples para gerenciar apólices de seguro, com **3 tipos de usuários**:
 
### Regras

- Um **cliente** pode visualizar apenas as suas próprias apólices 
- Um **operador** pode criar e visualizar todas as apólices   
- Um **admin** pode criar, editar, excluir e visualizar todas as apólices
- A apólice deve conter no mínimo:
  - Número da apólice com 12 dígitos
  - ID do cliente
  - Início de vigência
  - Fim de vigência
  - Status  
  (Fique à vontade para trazer outros dados que julgar relevantes)
- As permissões devem ser devidamente aplicadas nas controllers

---

### Critérios de Avaliação

- Interpretação do problema
- Solução desenvolvida
- Legibilidade do código
- Zelo com a entrega/descrição da solução

---

### Requisitos

- **Ruby:** 3.2.1
- **Ruby on Rails:** indiferente
- **Banco de dados:** relacional

---

### Entrega

- **Prazo:** 02/08
- **Link:** GitHub ou GitLab

Quando terminar, responda este e-mail com o link do repositório público no GitHub ou GitLab.

Você terá até o dia **02/08** para terminar. Se não conseguir finalizar tudo no tempo, envie o que conseguiu.



## 📝 Instruções
# Necessario Docker na máquina

$git clone https://github.com/juniomenchik/seg-dev-challenge.git
$cd seg-dev-challenge
$docker-compose up -d


# Collection POSTMAN v2
- postman/v1/seg-dev-challenge.postman_collection.json
# Acesse o banco de dados em http://localhost:5400/

# gerar token
curl --location --request POST 'http://localhost:3000/app/token' \
--header 'Authorization: Basic anVuaW9tZW5jaGlrOjExMTEyMDAw'

# Para verificar os logs no Splunk
http://localhost:8000/

source="*" (index="*")
![img.png](img.png)
![img_1.png](img_1.png)

# Melhorias no futuro.
 - Implementar Observabilidade para monitoramento
   - Splunk melhor configurado.
 - Implementar Servico de Mensageria para eventos
   - Kafka, RabbitMQ
 - Implementar testes mais descritivos
   - RSpec
