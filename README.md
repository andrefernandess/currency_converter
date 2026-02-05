# 💱 Currency Converter API

API REST para conversão de moedas em tempo real, desenvolvida em Ruby on Rails.

## 📖 Sobre o Projeto

API para conversão de moedas que utiliza a **Currency API** para obter taxas de câmbio atualizadas em tempo real. O sistema registra todas as conversões realizadas e permite consultar o histórico por usuário.

### Moedas Suportadas

- 🇺🇸 **USD** - Dólar Americano
- 🇧🇷 **BRL** - Real Brasileiro
- 🇪🇺 **EUR** - Euro
- 🇯🇵 **JPY** - Iene Japonês

---

## 🛠️ Tecnologias

- **Ruby** 3.3.6
- **Rails** 7.1.6
- **PostgreSQL**
- **RSpec** - Testes
- **Faraday** - HTTP Client
- **FactoryBot** - Test fixtures

---

## ✨ Funcionalidades

- ✅ Conversão de moedas em tempo real
- ✅ Registro de todas as transações
- ✅ Histórico de conversões por usuário
- ✅ Validações robustas de entrada
- ✅ Tratamento de erros padronizado
- ✅ API RESTful com respostas em JSON
- ✅ Testes

---

## 📋 Pré-requisitos

Antes de começar, você precisa ter instalado:

- [Ruby 3.3.6](https://www.ruby-lang.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Bundler](https://bundler.io/)
- Conta na [Currency API](https://currencyapi.com/) (plano gratuito disponível)

---

## 🚀 Instalação

### 1. Clone o repositório

```bash
git clone git@github.com:andrefernandess/currency_converter.git
cd currency-converter-api
```

### 2. Instale as dependências

```bash
bundle install
```

### 3. Configure o banco de dados

```bash
rails db:create
rails db:migrate
```

## ⚙️ Configuração

### 1. Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# .env
CURRENCY_API_KEY=your_api_key_here
CURRENCY_API_URL=https://api.currencyapi.com/v3
```

### 2. Obter API Key

1. Acesse [currencyapi.com](https://currencyapi.com/)
2. Crie uma conta gratuita
3. Copie sua API Key do dashboard
4. Cole no arquivo `.env`

### 3. Configurar PostgreSQL (se necessário)

Edite `config/database.yml` com suas credenciais:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: seu_usuario
  password: sua_senha
  host: localhost
```

## 🏃 Executando o Projeto

### Servidor de Desenvolvimento

```bash
rails server
```

A API estará disponível em: `http://localhost:3000`

### Console do Rails

```bash
rails console
```

## 🧪 Executando os Testes

### Todos os testes

```bash
rspec
```

---

## 🌐 Endpoints da API

### Base URL

```
http://localhost:3000/api/v1
```

### Endpoints Disponíveis

| Método | Endpoint | Descrição |
| --- | --- | --- |
| POST | /convert | Realizar conversão de moeda |
| GET | /transactions?user_id={id} | Listar conversões de um usuário |

## 📝 Exemplos de Uso

### 1. Converter Moeda

**Request:**

```bash
curl -X POST "http://localhost:3000/api/v1/convert" \
  -H "Content-Type: application/json" \
  -d '{
    "conversion": {
      "user_id": 123,
      "from_currency": "USD",
      "to_currency": "BRL",
      "amount": 100
    }
  }'
```

**Response (201 Created):**

```json
{
  "transaction_id": 42,
  "user_id": 123,
  "from_currency": "USD",
  "to_currency": "BRL",
  "from_value": 100.0,
  "to_value": 525.32,
  "rate": 5.2532,
  "timestamp": "2024-05-19T18:00:00Z"
}
```

### 2. Listar Histórico de Conversões

**Request:**

```bash
curl -X GET "http://localhost:3000/api/v1/transactions?user_id=123"
```

**Response (200 OK):**

```json
[
  {
    "transaction_id": 42,
    "user_id": 123,
    "from_currency": "USD",
    "to_currency": "BRL",
    "from_value": 100.0,
    "to_value": 525.32,
    "rate": 5.2532,
    "timestamp": "2024-05-19T18:00:00Z"
  },
  {
    "transaction_id": 41,
    "user_id": 123,
    "from_currency": "EUR",
    "to_currency": "JPY",
    "from_value": 50.0,
    "to_value": 8100.0,
    "rate": 162.0,
    "timestamp": "2024-05-19T17:30:00Z"
  }
]
```

### 3. Tratamento de Erros

**Moedas Iguais (422):**

```bash
curl -X POST "http://localhost:3000/api/v1/convert" \
  -H "Content-Type: application/json" \
  -d '{
    "conversion": {
      "user_id": 123,
      "from_currency": "USD",
      "to_currency": "USD",
      "amount": 100
    }
  }'
```

**Valor Inválido (422):**

```bash
curl -X POST "http://localhost:3000/api/v1/convert" \
  -H "Content-Type: application/json" \
  -d '{
    "conversion": {
      "user_id": 123,
      "from_currency": "USD",
      "to_currency": "BRL",
      "amount": 0
    }
  }'
```

**Response:**

```json
{
  "error": "Amount must be greater than zero"
}
```

---

## 📁 Estrutura do Projeto

```
currency-converter-api/
├── app/
│   ├── controllers/
│   │   ├── concerns/
│   │   │   └── api_error_handler.rb      # Tratamento global de erros
│   │   └── api/
│   │       └── v1/
│   │           ├── conversions_controller.rb
│   │           └── transactions_controller.rb
│   ├── models/
│   │   └── transaction.rb                # Model de transação
│   ├── serializers/
│   │   └── transaction_serializer.rb     # Formatação de resposta
│   └── services/
│       ├── currency_api_client_service.rb   # Cliente da API externa
│       └── currency_converter_service.rb    # Lógica de conversão
├── config/
│   ├── routes.rb                         # Rotas da API
│   └── database.yml                      # Configuração do banco
├── db/
│   └── migrate/
│       └── XXXXXX_create_transactions.rb # Migration de transações
├── spec/
│   ├── factories/
│   │   └── transactions.rb               # Factory para testes
│   ├── models/
│   │   └── transaction_spec.rb
│   ├── services/
│   │   ├── currency_api_client_service_spec.rb
│   │   └── currency_converter_service_spec.rb
│   └── controllers/
│       └── api/
│           └── v1/
│               ├── conversions_controller_spec.rb
│               └── transactions_controller_spec.rb
├── .env.example                          # Exemplo de variáveis de ambiente
├── .gitignore
├── Gemfile
└── README.md
```

## 📚 Documentação da API

### Swagger UI (Interativo)
Acesse a documentação interativa da API:

## http://localhost:3000/api-docs

## 🧑‍💻 Autor

### Andre Luiz Fernandes