class TransactionSerializer
  def initialize(transaction)
    @transaction = transaction
  end

  def as_json
    {
      transaction_id: @transaction.id,
      user_id: @transaction.user_id,
      from_currency: @transaction.from_currency,
      to_currency: @transaction.to_currency,
      from_value: @transaction.from_value.to_f,
      to_value: @transaction.to_value.to_f,
      rate: @transaction.rate.to_f,
      timestamp: @transaction.created_at.utc.iso8601
    }
  end

  def self.collection(transactions)
    transactions.map { |transaction| new(transaction).as_json }
  end
end