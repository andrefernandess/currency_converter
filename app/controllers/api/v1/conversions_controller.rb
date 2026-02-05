# frozen_string_literal: true

class Api::V1::ConversionsController < ApplicationController
  include ApiErrorHandler

  def create
    result = conversion_service.call(
      user_id: conversion_params[:user_id],
      from_currency: conversion_params[:from_currency],
      to_currency: conversion_params[:to_currency],
      amount: conversion_params[:amount]
    )

    render json: TransactionSerializer.new(result).as_json, status: :created
  end

  private

  def conversion_params
    params.require(:conversion).permit(:user_id, :from_currency, :to_currency, :amount)
  end

  def conversion_service
    @conversion_service ||= Transactions::Services::CreateTransactionService.new
  end
end
