# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::ValueObjects::Currency do
  describe ".new" do
    context "com moeda válida" do
      it "cria currency USD" do
        currency = described_class.new("USD")
        expect(currency.code).to eq("USD")
      end

      it "cria currency em minúsculo e normaliza" do
        currency = described_class.new("brl")
        expect(currency.code).to eq("BRL")
      end

      it "aceita todas as moedas suportadas" do
        %w[USD BRL EUR JPY].each do |code|
          currency = described_class.new(code)
          expect(currency.code).to eq(code)
        end
      end
    end

    context "com moeda inválida" do
      it "rejeita moeda não suportada" do
        expect { described_class.new("XXX") }
          .to raise_error(ArgumentError, /Invalid currency/)
      end

      it "rejeita valor nil" do
        expect { described_class.new(nil) }
          .to raise_error(ArgumentError)
      end

      it "rejeita string vazia" do
        expect { described_class.new("") }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#==" do
    it "é igual quando mesmo código" do
      currency1 = described_class.new("USD")
      currency2 = described_class.new("USD")
      expect(currency1).to eq(currency2)
    end

    it "é diferente quando códigos diferentes" do
      currency1 = described_class.new("USD")
      currency2 = described_class.new("BRL")
      expect(currency1).not_to eq(currency2)
    end
  end

  describe "#to_s" do
    it "retorna o código" do
      currency = described_class.new("EUR")
      expect(currency.to_s).to eq("EUR")
    end
  end
end
