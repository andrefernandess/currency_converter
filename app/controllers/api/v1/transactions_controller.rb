class Api::V1::TransactionsController < ApplicationController
  def index
    user_id = params[:user_id]
  
    if user_id.blank?
      render json: { error: "user_id parameter is required" }, status: :bad_request
      return
    end

    transactions = Transaction.where(user_id: user_id).order(created_at: :desc)
    render json: transactions.map { |transaction| format_response(transaction) }, status: :ok
  end

  private
  def format_response(transaction)
    {
      transaction_id: transaction.id,
      user_id: transaction.user_id,
      from_currency: transaction.from_currency,
      to_currency: transaction.to_currency,
      from_value: transaction.from_value.to_f,
      to_value: transaction.to_value.to_f,
      rate: transaction.rate.to_f,
      timestamp: transaction.created_at.utc.iso8601
    }
  end
end
