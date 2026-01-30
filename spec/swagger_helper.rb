# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Currency Converter API',
        version: 'v1',
        description: 'API REST para conversão de moedas em tempo real',
        contact: {
          name: 'Andre',
          email: 'andre.l.fernandess@hotmail.com'
        }
      },
      paths: {},
      servers: [
        {
          url: 'https://currency-converter-api-zay7.onrender.com',
          description: 'Servidor de Produção (Render)'
        },
        {
          url: 'http://localhost:3000',
          description: 'Servidor de Desenvolvimento (Local)'
        }
      ]
    }
  }

  config.openapi_format = :yaml
end
