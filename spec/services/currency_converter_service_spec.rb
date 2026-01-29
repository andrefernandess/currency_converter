require "rails_helper"

RSpec.describe CurrencyConverterService do
  let(:user_id) { 123 }
  let(:from_currency) { "USD" }
  let(:to_currency) { "BRL" }
  let(:amount) { 100.0 }

  let(:service) do
    described_class.new(
      user_id: user_id,
      from_currency: from_currency,
      to_currency: to_currency,
      amount: amount
    )
  end

  let(:mock_api_response) do
    {
      "data" => {
        "BRL" => {
          "code" => "BRL",
          "value" => 5.2532
        }
      }
    }
  end

  before do
    allow_any_instance_of(CurrencyApiClientService)
      .to receive(:latest_rates)
      .and_return(mock_api_response)
  end

  describe "initialize" do
    it "sets instance variables correctly" do
      expect(service.instance_variable_get(:@user_id)).to eq(user_id)
      expect(service.instance_variable_get(:@from_currency)).to eq(from_currency)
      expect(service.instance_variable_get(:@to_currency)).to eq(to_currency)
      expect(service.instance_variable_get(:@amount)).to eq(amount)
    end
  end

  describe "#call" do
    context "with valid parameters" do
      it "creates a new Transaction" do
        expect { service.call }.to change(Transaction, :count).by(1)
      end
    end
  end

end