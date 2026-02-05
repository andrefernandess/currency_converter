# frozen_string_literal: true

class Api::V1::TransactionsController < ApplicationController
  include ApiErrorHandler

  before_action :validate_user_id!, only: [:index]

  def index
    transactions = transaction_repository.find_by_user(params[:user_id])

    render json: TransactionSerializer.collection(transactions), status: :ok
  end

  private

  def validate_user_id!
    raise ArgumentError, "user_id parameter is required" if params[:user_id].blank?
  end

  def transaction_repository
    @transaction_repository ||= Transactions::Repositories::TransactionRepository.new
  end
end
