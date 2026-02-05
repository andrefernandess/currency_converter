# frozen_string_literal: true

module Transactions
  module Clients
    class FakeExchangeClient
      include ExchangeRateClientInterface

      RATES = {
        "BRL_USD" => BigDecimal("0.185"),
        "USD_BRL" => BigDecimal("5.40"),
        "BRL_EUR" => BigDecimal("0.17"),
        "EUR_BRL" => BigDecimal("5.88"),
        "USD_EUR" => BigDecimal("0.92"),
        "EUR_USD" => BigDecimal("1.09")
      }.freeze

      def get_rate(from_currency, to_currency)
        key = "#{from_currency.to_s.upcase}_#{to_currency.to_s.upcase}"
        RATES[key] || raise(ExchangeRateError, "Rate not found: #{key}")
      end
    end
  end
end
