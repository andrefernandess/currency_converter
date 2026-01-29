class Api::V1::ConversionsController < ApplicationController
  include ApiErrorHandler
  
  def create
    converter = create_converter

    transaction = converter.call

    render json: TransactionSerializer.new(transaction).as_json, status: :created
  end

  private

  def conversion_params
    params.require(:conversion).permit(:user_id, :from_currency, :to_currency, :amount)
  end

  def create_converter
    CurrencyConverterService.new(
      user_id: conversion_params[:user_id],
      from_currency: conversion_params[:from_currency],
      to_currency: conversion_params[:to_currency],
      amount: conversion_params[:amount]
    )
  end
end
