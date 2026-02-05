# frozen_string_literal: true

require "faraday"

module Transactions
  module Clients
    class CurrencyApiClient
      include ExchangeRateClientInterface

      BASE_URL = "https://api.currencyapi.com/v3/"

      def initialize(api_key: ENV["CURRENCY_API_KEY"])
        @api_key = api_key
        validate_api_key!
      end

      def get_rate(from_currency, to_currency)
        from = from_currency.to_s.upcase
        to = to_currency.to_s.upcase

        response = fetch_latest_rate(from, to)
        extract_rate(response, to)
      end

      private

      def validate_api_key!
        raise ArgumentError, "CURRENCY_API_KEY is required" if @api_key.nil? || @api_key.empty?
      end

      def fetch_latest_rate(base_currency, target_currency)
        response = connection.get("latest") do |req|
          req.params["apikey"] = @api_key
          req.params["base_currency"] = base_currency
          req.params["currencies"] = target_currency
        end

        handle_response(response)
      end

      def connection
        @connection ||= Faraday.new(url: BASE_URL) do |faraday|
          faraday.request :url_encoded
          faraday.options.timeout = 10
          faraday.options.open_timeout = 5
          faraday.adapter Faraday.default_adapter
        end
      end

      def handle_response(response)
        return JSON.parse(response.body) if response.success?

        raise ExchangeRateError, "API request failed: #{response.status} - #{response.body}"
      end

      def extract_rate(response, target_currency)
        rate = response.dig("data", target_currency, "value")
        raise ExchangeRateError, "Rate not found for #{target_currency}" unless rate

        BigDecimal(rate.to_s)
      end
    end

    class ExchangeRateError < StandardError; end
  end
end
