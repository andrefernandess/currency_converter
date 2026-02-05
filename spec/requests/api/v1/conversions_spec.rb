# spec/requests/api/v1/conversions_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/conversions', type: :request do
  path '/api/v1/convert' do
    post 'Converter moeda' do
      tags 'Conversões'
      description 'Realiza a conversão entre duas moedas utilizando taxas em tempo real'
      consumes 'application/json'
      produces 'application/json'

      let(:user) { create(:user) }
      
      parameter name: :conversion, in: :body, schema: {
        type: :object,
        properties: {
          conversion: {
            type: :object,
            properties: {
              user_id: { type: :integer, example: 123, description: 'ID do usuário' },
              from_currency: { type: :string, example: 'USD', description: 'Moeda de origem (USD, BRL, EUR, JPY)' },
              to_currency: { type: :string, example: 'BRL', description: 'Moeda de destino (USD, BRL, EUR, JPY)' },
              amount: { type: :number, example: 100.0, description: 'Valor a ser convertido' }
            },
            required: ['user_id', 'from_currency', 'to_currency', 'amount']
          }
        }
      }

      response '201', 'Conversão realizada com sucesso' do
        schema type: :object,
               properties: {
                 transaction_id: { type: :integer, example: 42 },
                 user_id: { type: :integer, example: 123 },
                 from_currency: { type: :string, example: 'USD' },
                 to_currency: { type: :string, example: 'BRL' },
                 from_value: { type: :number, example: 100.0 },
                 to_value: { type: :number, example: 525.32 },
                 rate: { type: :number, example: 5.2532 },
                 timestamp: { type: :string, example: '2024-05-19T18:00:00Z' }
               }

        let(:conversion) do
          {
            conversion: {
              user_id: user.id,
              from_currency: 'USD',
              to_currency: 'BRL',
              amount: 100.0
            }
          }
        end

        before do
          allow_any_instance_of(CurrencyApiClientService).to receive(:latest_rates).and_return(
            { 'data' => { 'BRL' => { 'value' => 5.2532 } } }
          )
        end

        run_test!
      end

      response '422', 'Moedas iguais' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'From and To currencies must be different' }
               }

        let(:conversion) do
          {
            conversion: {
              user_id: user.id,
              from_currency: 'USD',
              to_currency: 'USD',
              amount: 100.0
            }
          }
        end

        run_test!
      end

      response '422', 'Valor inválido' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Amount must be greater than zero' }
               }

        let(:conversion) do
          {
            conversion: {
              user_id: user.id,
              from_currency: 'USD',
              to_currency: 'BRL',
              amount: 0
            }
          }
        end

        run_test!
      end

      response '400', 'Parâmetro ausente' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Missing required parameter: conversion' }
               }

        let(:conversion) do
          {}
        end

        run_test!
      end
    end
  end
end
