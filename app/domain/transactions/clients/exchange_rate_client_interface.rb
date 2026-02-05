# frozen_string_literal: true

module Transactions
  module Clients
    module ExchangeRateClientInterface
      def get_rate(from_currency, to_currency)
        raise NotImplementedError
      end
    end
  end
end
