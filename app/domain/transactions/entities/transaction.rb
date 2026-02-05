# frozen_string_literal: true

module Transactions
  module Entities
    class Transaction
      attr_reader :id, :user_id, :from_money, :to_money, :rate, :created_at

      def initialize(user_id:, from_money:, to_money:, rate:, id: nil, created_at: nil)
        @id = id
        @user_id = user_id
        @from_money = ensure_money(from_money)
        @to_money = ensure_money(to_money)
        @rate = BigDecimal(rate.to_s)
        @created_at = created_at || Time.current

        validate!
      end

      def from_currency
        from_money.currency.code
      end

      def to_currency
        to_money.currency.code
      end

      def from_value
        from_money.amount
      end

      def to_value
        to_money.amount
      end

      def persisted?
        !id.nil?
      end

      def to_s
        "Transaction ##{id}: #{from_money} → #{to_money} (rate: #{rate})"
      end

      private

      def ensure_money(value)
        return value if value.is_a?(ValueObjects::Money)
        raise ArgumentError, "Expected Money, got #{value.class}"
      end

      def validate!
        validate_user!
        validate_rate!
        validate_different_currencies!
      end

      def validate_user!
        raise ArgumentError, "User ID is required" if user_id.nil?
        raise ArgumentError, "User ID must be a positive integer" unless user_id.is_a?(Integer) && user_id > 0
      end

      def validate_rate!
        raise ArgumentError, "Rate must be greater than zero" if rate <= 0
      end

      def validate_different_currencies!
        if from_money.currency == to_money.currency
          raise ArgumentError, "Source and target currencies must be different"
        end
      end
    end
  end
end
