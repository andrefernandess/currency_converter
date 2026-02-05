
# frozen_string_literal: true

module Transactions
  module Repositories
    class TransactionRepository
      include TransactionRepositoryInterface

      def save(entity)
        record = Transaction.create!(
          user_id: entity.user_id,
          from_currency: entity.from_currency,
          to_currency: entity.to_currency,
          from_value: entity.from_value,
          to_value: entity.to_value,
          rate: entity.rate
        )

        to_entity(record)
      end

      def find_by_id(id)
        record = Transaction.find_by(id: id)
        return nil unless record

        to_entity(record)
      end

      def find_by_user(user_id, limit: 10)
        records = Transaction.where(user_id: user_id)
                             .order(created_at: :desc)
                             .limit(limit)

        records.map { |record| to_entity(record) }
      end

      private

      def to_entity(record)
        from_money = ValueObjects::Money.new(
          amount: record.from_value,
          currency: record.from_currency
        )

        to_money = ValueObjects::Money.new(
          amount: record.to_value,
          currency: record.to_currency
        )

        Entities::Transaction.new(
          id: record.id,
          user_id: record.user_id,
          from_money: from_money,
          to_money: to_money,
          rate: record.rate,
          created_at: record.created_at
        )
      end
    end
  end
end
