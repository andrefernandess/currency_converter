# spec/requests/api/v1/transactions_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/transactions', type: :request do
  path '/api/v1/transactions' do
    get 'Listar transações do usuário' do
      tags 'Transações'
      description 'Lista todas as conversões realizadas por um usuário, ordenadas da mais recente para a mais antiga'
      produces 'application/json'
      
      parameter name: :user_id, 
                in: :query, 
                type: :integer, 
                required: true, 
                description: 'ID do usuário',
                example: 123

      response '200', 'Lista de transações' do
        schema type: :array,
               items: {
                 type: :object,
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
               }

        let(:user_id) { 123 }

        before do
          allow_any_instance_of(CurrencyApiClientService).to receive(:latest_rates).and_return(
            { 'data' => { 'BRL' => { 'value' => 5.2532 } } }
          )

          CurrencyConverterService.new(
            user_id: 123,
            from_currency: 'USD',
            to_currency: 'BRL',
            amount: 100
          ).call
        end

        run_test!
      end

      response '200', 'Lista vazia (usuário sem transações)' do
        schema type: :array, items: {}

        let(:user_id) { 999 }

        run_test!
      end

      response '422', 'user_id ausente' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'user_id parameter is required' }
               }

        let(:user_id) { nil }

        run_test!
      end
    end
  end
end
