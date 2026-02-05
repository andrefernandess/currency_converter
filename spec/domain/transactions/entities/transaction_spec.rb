# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::Entities::Transaction do
  let(:from_money) do
    Transactions::ValueObjects::Money.new(
      amount: 100,
      currency: Transactions::ValueObjects::Currency.new("USD")
    )
  end

  let(:to_money) do
    Transactions::ValueObjects::Money.new(
      amount: 524,
      currency: Transactions::ValueObjects::Currency.new("BRL")
    )
  end

  describe ".new" do
    context "com parâmetros válidos" do
      it "cria transaction com todos os atributos" do
        transaction = described_class.new(
          id: 1,
          user_id: 42,
          from_money: from_money,
          to_money: to_money,
          rate: 5.24,
          created_at: Time.current
        )

        expect(transaction.id).to eq(1)
        expect(transaction.user_id).to eq(42)
        expect(transaction.rate).to eq(5.24)
      end

      it "cria transaction sem id (novo registro)" do
        transaction = described_class.new(
          user_id: 42,
          from_money: from_money,
          to_money: to_money,
          rate: 5.24
        )

        expect(transaction.id).to be_nil
      end
    end

    context "com parâmetros inválidos" do
      it "rejeita user_id nil" do
        expect {
          described_class.new(
            user_id: nil,
            from_money: from_money,
            to_money: to_money,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /User ID is required/)
      end

      it "rejeita from_money nil" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: nil,
            to_money: to_money,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /Expected Money/)
      end

      it "rejeita to_money nil" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: nil,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /Expected Money/)
      end

      it "rejeita rate nil" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: to_money,
            rate: nil
          )
        }.to raise_error(ArgumentError)
      end

      it "rejeita rate zero" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: to_money,
            rate: 0
          )
        }.to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejeita rate negativo" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: to_money,
            rate: -1.5
          )
        }.to raise_error(ArgumentError, /must be greater than zero/)
      end
    end

  end

  describe "delegated methods" do
    subject do
      described_class.new(
        user_id: 42,
        from_money: from_money,
        to_money: to_money,
        rate: 5.24
      )
    end

    it "#from_currency retorna código da moeda origem" do
      expect(subject.from_currency).to eq("USD")
    end

    it "#to_currency retorna código da moeda destino" do
      expect(subject.to_currency).to eq("BRL")
    end

    it "#from_value retorna valor origem" do
      expect(subject.from_value).to eq(100)
    end

    it "#to_value retorna valor destino" do
      expect(subject.to_value).to eq(524)
    end
  end
end
