
# frozen_string_literal: true

module Transactions
  module ValueObjects
    class Money
      attr_reader :amount, :currency

      def initialize(amount:, currency:)
        @amount = parse_amount(amount)
        @currency = ensure_currency(currency)

        validate!
      end

      def ==(other)
        return false unless other.is_a?(Money)
        amount == other.amount && currency == other.currency
      end
      alias eql? ==

      def hash
        [amount, currency].hash
      end

      def to_s
        "#{format('%.2f', amount)} #{currency}"
      end

      private

      def parse_amount(value)
        BigDecimal(value.to_s)
      rescue ArgumentError
        raise ArgumentError, "Invalid amount: #{value}"
      end

      def ensure_currency(value)
        return value if value.is_a?(Currency)
        Currency.new(value)
      end

      def validate!
        raise ArgumentError, "Amount must be greater than zero" if amount <= 0
      end
    end
  end
end
