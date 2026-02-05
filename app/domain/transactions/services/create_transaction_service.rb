# frozen_string_literal: true

module Transactions
  module Services
    class CreateTransactionService
      def initialize(repository: Repositories::TransactionRepository.new, exchange_rate_client: nil)
        @repository = repository
        @exchange_rate_client = exchange_rate_client || default_exchange_client
      end

      def call(user_id:, from_currency:, to_currency:, amount:)
        # 1. Buscar taxa de câmbio
        rate = fetch_exchange_rate(from_currency, to_currency)

        # 2. Calcular valor convertido
        converted_amount = calculate_conversion(amount, rate)

        # 3. Criar Value Objects
        from_money = ValueObjects::Money.new(amount: amount, currency: from_currency)
        to_money = ValueObjects::Money.new(amount: converted_amount, currency: to_currency)

        # 4. Criar Entity
        entity = Entities::Transaction.new(
          user_id: user_id,
          from_money: from_money,
          to_money: to_money,
          rate: rate
        )

        # 5. Persistir e retornar
        @repository.save(entity)
      end

      private

      def fetch_exchange_rate(from, to)
        @exchange_rate_client.get_rate(from, to)
      end

      def calculate_conversion(amount, rate)
        (BigDecimal(amount.to_s) * BigDecimal(rate.to_s)).round(2)
      end

      def default_exchange_client
        Clients::CurrencyApiClient.new
      end
    end
  end
end
