# frozen_string_literal: true

class CountersController < ApplicationController
  def show; end

  def call
    @contract_name = params[:contract_name]
    @result = NearApi::Action.new(@contract_name, function_call).call
  end

  def double_call
    @contract_name = params[:contract_name]
    @result = NearApi::Action.new(@contract_name, [function_call, function_call]).call
    render 'call'
  end

  private

  def function_call
    NearApi::Action::FunctionCall.new(
      'increment',
      '{}',
      gas: 30_000_000_000_000,
      amount: 0
    )
  end
end
