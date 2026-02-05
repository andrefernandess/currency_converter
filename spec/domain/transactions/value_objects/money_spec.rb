# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::ValueObjects::Money do
  let(:usd) { Transactions::ValueObjects::Currency.new("USD") }
  let(:brl) { Transactions::ValueObjects::Currency.new("BRL") }

  describe ".new" do
    context "com valores válidos" do
      it "cria money com amount e currency" do
        money = described_class.new(amount: 100, currency: usd)
        
        expect(money.amount).to eq(100)
        expect(money.currency).to eq(usd)
      end

      it "aceita string como amount" do
        money = described_class.new(amount: "99.99", currency: usd)
        expect(money.amount).to eq(BigDecimal("99.99"))
      end

      it "aceita BigDecimal como amount" do
        money = described_class.new(amount: BigDecimal("50.5"), currency: brl)
        expect(money.amount).to eq(BigDecimal("50.5"))
      end
    end

    context "com valores inválidos" do
      it "rejeita amount negativo" do
        expect { described_class.new(amount: -10, currency: usd) }
          .to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejeita amount zero" do
        expect { described_class.new(amount: 0, currency: usd) }
          .to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejeita currency nil" do
        expect { described_class.new(amount: 100, currency: nil) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#currency" do
    it "retorna o código da moeda" do
      money = described_class.new(amount: 100, currency: brl)
      expect(money.currency.code).to eq("BRL")
    end
  end

  describe "#==" do
    it "é igual quando mesmo amount e currency" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 100, currency: usd)
      expect(money1).to eq(money2)
    end

    it "é diferente quando amounts diferentes" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 200, currency: usd)
      expect(money1).not_to eq(money2)
    end

    it "é diferente quando currencies diferentes" do
      money1 = described_class.new(amount: 100, currency: usd)
      money2 = described_class.new(amount: 100, currency: brl)
      expect(money1).not_to eq(money2)
    end
  end

  describe "#to_s" do
    it "formata com 2 casas decimais e código" do
      money = described_class.new(amount: 1234.5, currency: brl)
      expect(money.to_s).to eq("1234.50 BRL")
    end
  end
end

