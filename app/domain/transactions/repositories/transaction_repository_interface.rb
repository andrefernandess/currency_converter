# frozen_string_literal: true

module Transactions
  module Repositories
    module TransactionRepositoryInterface
      def save(entity)
        raise NotImplementedError
      end

      def find_by_id(id)
        raise NotImplementedError
      end

      def find_by_user(user_id, limit: 10)
        raise NotImplementedError
      end
    end
  end
end
