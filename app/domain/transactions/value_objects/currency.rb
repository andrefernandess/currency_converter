# frozen_string_literal: true

module Transactions
  module ValueObjects
    class Currency
      VALID_CURRENCIES = %w[BRL USD EUR JPY].freeze

      attr_reader :code

      def initialize(code)
        @code = code.to_s.upcase.strip

        validate!
      end

      def ==(other)
        return false unless other.is_a?(Currency)
        code == other.code
      end
      alias eql? ==

      def hash
        code.hash
      end

      def to_s
        code
      end

      private

      def validate!
        raise ArgumentError, "Currency code is required" if code.empty?
        raise ArgumentError, "Invalid currency: #{code}. Valid: #{VALID_CURRENCIES.join(', ')}" unless valid?
      end

      def valid?
        VALID_CURRENCIES.include?(code)
      end
    end
  end
end
