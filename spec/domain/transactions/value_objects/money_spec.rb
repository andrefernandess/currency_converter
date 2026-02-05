# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::ValueObjects::Money do
  let(:usd) { Transactions::ValueObjects::Currency.new("USD") }
  let(:brl) { Transactions::ValueObjects::Currency.new("BRL") }

  describe ".new" do
    context "with valid values" do
      it "creates money with amount and currency" do
        money = described_class.new(amount: 100, currency: usd)
        
        expect(money.amount).to eq(100)
        expect(money.currency).to eq(usd)
      end

      it "accepts string as amount" do
        money = described_class.new(amount: "99.99", currency: usd)
        expect(money.amount).to eq(BigDecimal("99.99"))
      end

      it "accepts BigDecimal as amount" do
        money = described_class.new(amount: BigDecimal("50.5"), currency: brl)
        expect(money.amount).to eq(BigDecimal("50.5"))
      end
    end

    context "with invalid values" do
      it "rejects negative amount" do
        expect { described_class.new(amount: -10, currency: usd) }
          .to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejects zero amount" do
        expect { described_class.new(amount: 0, currency: usd) }
          .to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejects nil currency" do
        expect { described_class.new(amount: 100, currency: nil) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#currency" do
    it "returns the currency code" do
      money = described_class.new(amount: 100, currency: brl)
      expect(money.currency.code).to eq("BRL")
    end
  end

  describe "#==" do
    it "is equal when same amount and currency" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 100, currency: usd)
      expect(money1).to eq(money2)
    end

    it "is different when amounts are different" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 200, currency: usd)
      expect(money1).not_to eq(money2)
    end

    it "is different when currencies are different" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 100, currency: brl)
      expect(money1).not_to eq(money2)
    end
  end

  describe "#to_s" do
    it "formats with 2 decimal places and code" do
      money = described_class.new(amount: 1234.5, currency: brl)
      expect(money.to_s).to eq("1234.50 BRL")
    end
  end
end

