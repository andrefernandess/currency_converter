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
    it "persiste a transaction no banco" do
      expect { repository.save(transaction_entity) }
        .to change(Transaction, :count).by(1)
    end

    it "retorna a entity com id preenchido" do
      saved = repository.save(transaction_entity)

      expect(saved).to be_a(Transactions::Entities::Transaction)
      expect(saved.id).to be_present
    end

    it "persiste os valores corretos" do
      saved = repository.save(transaction_entity)
      record = Transaction.last

      expect(record.user_id).to eq(user.id)
      expect(record.from_currency).to eq("USD")
      expect(record.to_currency).to eq("BRL")
      expect(record.from_value).to eq(100)
      expect(record.to_value).to eq(524)
      expect(record.rate).to eq(5.24)
    end
  end

  describe "#find_by_user" do
    context "quando usuário tem transactions" do
      before do
        create(:transaction, user: user, from_currency: "USD", to_currency: "BRL")
        create(:transaction, user: user, from_currency: "EUR", to_currency: "BRL")
      end

      it "retorna lista de entities" do
        result = repository.find_by_user(user.id)

        expect(result).to all(be_a(Transactions::Entities::Transaction))
        expect(result.size).to eq(2)
      end

      it "ordena por data decrescente" do
        result = repository.find_by_user(user.id)

        expect(result.first.created_at).to be >= result.last.created_at
      end
    end

    context "quando usuário não tem transactions" do
      it "retorna lista vazia" do
        result = repository.find_by_user(user.id)

        expect(result).to eq([])
      end
    end

    context "não retorna transactions de outros usuários" do
      let!(:other_user) { create(:user) }

      before do
        create(:transaction, user: user)
        create(:transaction, user: other_user)
      end

      it "filtra apenas do usuário solicitado" do
        result = repository.find_by_user(user.id)

        expect(result.size).to eq(1)
        expect(result.first.user_id).to eq(user.id)
      end
    end
  end
end
