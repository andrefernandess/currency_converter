class Api::V1::TransactionsController < ApplicationController
  include ApiErrorHandler
  
  before_action :validate_user_id!, only: [:index]

  def index

    transactions = Transaction.where(user_id: params[:user_id]).order(created_at: :desc)
    render json: TransactionSerializer.collection(transactions), status: :ok
  end

  private

  def validate_user_id!
    raise ArgumentError, "user_id parameter is required" if params[:user_id].blank?
  end
end
