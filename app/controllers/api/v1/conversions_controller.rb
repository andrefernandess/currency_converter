class Api::V1::ConversionsController < ApplicationController
  def create
    converter = CurrencyConverterService.new(
      user_id: conversion_params[:user_id],
      from_currency: conversion_params[:from_currency],
      to_currency: conversion_params[:to_currency],
      amount: conversion_params[:amount]
    )

    transaction = converter.call

    render json: format_response(transaction), status: :created
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: "Conversion failed: #{e.message}" }, status: :internal_server_error
  end

  private

  def conversion_params
    params.require(:conversion).permit(:user_id, :from_currency, :to_currency, :amount)
  end

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
