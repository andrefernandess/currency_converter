require "faraday"

class CurrencyApiClient
  BASE_URL = "https://api.currencyapi.com/v3/".freeze

  def initialize(api_key = ENV["CURRENCY_API_KEY"])
    @api_key = api_key
  end

  def latest_rates(base_currency:, currencies:)
    response = connection.get("latest") do |req|
      req.params["apikey"] = @api_key
      req.params["base_currency"] = base_currency
      req.params["currencies"] = currencies.join(",")
    end

    parse_response(response)
  end

  private

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  def parse_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      raise "Currency API request failed with status #{response.status}"
    end
  end
end