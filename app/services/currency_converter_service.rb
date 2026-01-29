class CurrencyConverterService
  def initialize(user_id:, from_currency:, to_currency:, amount:)
    @user_id = user_id
    @from_currency = from_currency.upcase
    @to_currency = to_currency.upcase
    @amount = amount.to_f
    @api_client = CurrencyApiClientService.new
  end

  def call
    validate_inputs!

    rate_data = fetch_conversion_rate
    rate = extract_rate(rate_data)
    converted_value = calculate_converted_value(rate)

    create_transaction(rate, converted_value)
  end

  private

  def validate_inputs!
    validate_amount!
    validate_currencies!
  end

  def validate_amount!
    raise ArgumentError, "Amount must be greater than zero" if @amount <= 0
  end

  def validate_currencies!
    if @from_currency == @to_currency
      raise ArgumentError, "From and To currencies must be different"
    end
  end

  def fetch_conversion_rate
    response = @api_client.latest_rates(
      base_currency: @from_currency,
      currencies: [@to_currency]
    )
    
    response["data"][@to_currency] || raise(ArgumentError, "Conversion rate not found")
  end

  def extract_rate(rate_data)
    rate_data["value"].to_f
  end

  def calculate_converted_value(rate)
    (@amount * rate).round(2)
  end

  def create_transaction(rate, converted_value)
    Transaction.create!(
      user_id: @user_id,
      from_currency: @from_currency,
      to_currency: @to_currency,
      from_value: @amount,
      to_value: converted_value,
      rate: rate
    )
  end

end