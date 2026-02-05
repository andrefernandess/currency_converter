# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::ValueObjects::Currency do
  describe ".new" do
    context "with valid currency" do
      it "creates currency USD" do
        currency = described_class.new("USD")
        expect(currency.code).to eq("USD")
      end

      it "creates currency in lowercase and normalizes" do
        currency = described_class.new("brl")
        expect(currency.code).to eq("BRL")
      end

      it "accepts all supported currencies" do
        %w[USD BRL EUR JPY].each do |code|
          currency = described_class.new(code)
          expect(currency.code).to eq(code)
        end
      end
    end

    context "with invalid currency" do
      it "rejects unsupported currency" do
        expect { described_class.new("XXX") }
          .to raise_error(ArgumentError, /Invalid currency/)
      end

      it "rejects nil value" do
        expect { described_class.new(nil) }
          .to raise_error(ArgumentError)
      end

      it "rejects empty string" do
        expect { described_class.new("") }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#==" do
    it "is equal when same code" do
      currency1 = described_class.new("USD")
      currency2 = described_class.new("USD")
      expect(currency1).to eq(currency2)
    end

    it "is different when codes are different" do
      currency1 = described_class.new("USD")
      currency2 = described_class.new("BRL")
      expect(currency1).not_to eq(currency2)
    end
  end

  describe "#to_s" do
    it "returns the code" do
      currency = described_class.new("EUR")
      expect(currency.to_s).to eq("EUR")
    end
  end
end
