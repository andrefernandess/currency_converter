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
    context "with valid parameters" do
      it "creates transaction with all attributes" do
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

      it "creates transaction without id (new record)" do
        transaction = described_class.new(
          user_id: 42,
          from_money: from_money,
          to_money: to_money,
          rate: 5.24
        )

        expect(transaction.id).to be_nil
      end
    end

    context "with invalid parameters" do
      it "rejects nil user_id" do
        expect {
          described_class.new(
            user_id: nil,
            from_money: from_money,
            to_money: to_money,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /User ID is required/)
      end

      it "rejects nil from_money" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: nil,
            to_money: to_money,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /Expected Money/)
      end

      it "rejects nil to_money" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: nil,
            rate: 5.24
          )
        }.to raise_error(ArgumentError, /Expected Money/)
      end

      it "rejects nil rate" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: to_money,
            rate: nil
          )
        }.to raise_error(ArgumentError)
      end

      it "rejects zero rate" do
        expect {
          described_class.new(
            user_id: 42,
            from_money: from_money,
            to_money: to_money,
            rate: 0
          )
        }.to raise_error(ArgumentError, /must be greater than zero/)
      end

      it "rejects negative rate" do
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

    it "#from_currency returns the source currency code" do
      expect(subject.from_currency).to eq("USD")
    end

    it "#to_currency returns the target currency code" do
      expect(subject.to_currency).to eq("BRL")
    end

    it "#from_value returns the source value" do
      expect(subject.from_value).to eq(100)
    end

    it "#to_value returns the target value" do
      expect(subject.to_value).to eq(524)
    end
  end
end
