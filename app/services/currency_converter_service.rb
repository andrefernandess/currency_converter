class CurrencyConverterService
  def initialize(user_id:, from_currency:, to_currency:, amount:)
    @user_id = user_id
    @from_currency = from_currency.upcase
    @to_currency = to_currency.upcase
    @amount = amount.to_f
    @api_client = CurrencyApiClientService.new
  end

  def call
    validate_amount!

    rate_data = fetch_conversion_rate
    converted_value = calculate_converted_value(rate_data)

    create_transaction(rate_data, converted_value)
  end

  private

  def validate_amount!
    raise "Amount must be greater than zero" if @amount <= 0
  end

  def fetch_conversion_rate
    response = @api_client.latest_rates(
      base_currency: @from_currency,
      currencies: [@to_currency]
    )
    
    response["data"][@to_currency] || raise("Conversion rate not found")
  end

  def calculate_converted_value(rate_data)
    rate = rate_data["value"].to_f
    (@amount * rate).round(2)
  end

  def create_transaction(rate_data, converted_value)
    Transaction.create!(
      user_id: @user_id,
      from_currency: @from_currency,
      to_currency: @to_currency,
      from_value: @amount,
      to_value: converted_value,
      rate: rate_data["value"].to_f
    )
  end

end