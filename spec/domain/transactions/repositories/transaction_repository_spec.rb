# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transactions::Repositories::TransactionRepository do
  subject(:repository) { described_class.new }

  let!(:user) { create(:user) }

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

  let(:transaction_entity) do
    Transactions::Entities::Transaction.new(
      user_id: user.id,
      from_money: from_money,
      to_money: to_money,
      rate: 5.24
    )
  end

  describe "#save" do
    it "persisting the transaction on database" do
      expect { repository.save(transaction_entity) }
        .to change(Transaction, :count).by(1)
    end

    it "returns the entity with id filled" do
      saved = repository.save(transaction_entity)

      expect(saved).to be_a(Transactions::Entities::Transaction)
      expect(saved.id).to be_present
    end

    it "persists the correct values" do
      saved = repository.save(transaction_entity)
      record = Transaction.last

      expect(record.user_id).to eq(saved.user_id)
      expect(record.from_currency).to eq(saved.from_money.currency.code)
      expect(record.to_currency).to eq(saved.to_money.currency.code)
      expect(record.from_value).to eq(saved.from_money.amount)
      expect(record.to_value).to eq(saved.to_money.amount)
      expect(record.rate).to eq(saved.rate)
    end
  end

  describe "#find_by_user" do
    context "when user has transactions" do
      before do
        create(:transaction, user: user, from_currency: "USD", to_currency: "BRL")
        create(:transaction, user: user, from_currency: "EUR", to_currency: "BRL")
      end

      it "returns a list of entities" do
        result = repository.find_by_user(user.id)

        expect(result).to all(be_a(Transactions::Entities::Transaction))
        expect(result.size).to eq(2)
      end

      it "orders by descending date" do
        result = repository.find_by_user(user.id)

        expect(result.first.created_at).to be >= result.last.created_at
      end
    end

    context "when user has no transactions" do
      it "returns an empty list" do
        result = repository.find_by_user(user.id)

        expect(result).to eq([])
      end
    end

    context "does not return transactions from other users" do
      let!(:other_user) { create(:user) }

      before do
        create(:transaction, user: user)
        create(:transaction, user: other_user)
      end

      it "filters only the requested user's transactions" do
        result = repository.find_by_user(user.id)

        expect(result.size).to eq(1)
        expect(result.first.user_id).to eq(user.id)
      end
    end
  end
end
