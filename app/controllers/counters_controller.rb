# frozen_string_literal: true

class CountersController < ApplicationController
  before_action :save_values

  def show
    @contract_name = cookies[:contract_name]
    @key_pair = cookies[:key_pair]
  end

  def deploy
    @contract_name = params[:contract_name]
    @key_pair = params[:key_pair]
    contract = params[:contract]
    return error!('contract name required') if @contract_name.blank?
    return error!('keypair required') if @key_pair.blank?
    return error!('contract source required') if contract.blank?

    @deploy_result = NearApi::Transaction.new(
      @contract_name,
      NearApi::Actions::DeployContract.new(contract.read),
      key: ::NearApi::Key.new(@contract_name, key_pair: @key_pair)
    ).call
    render template: 'counters/show'
  end

  def call
    @contract_name = params[:contract_name]
    @key_pair = params[:key_pair]
    return error!('contract name required') if @contract_name.blank?
    return error!('keypair required') if @key_pair.blank?

    @result = NearApi::Transaction.new(
      @contract_name,
      function_call,
      key: ::NearApi::Key.new(@contract_name, key_pair: @key_pair)
    ).call
  end

  def double_call
    @contract_name = params[:contract_name]
    @key_pair = params[:key_pair]
    return error!('contract name required') if @contract_name.blank?
    return error!('keypair required') if @key_pair.blank?

    @result = NearApi::Transaction.new(
      @contract_name,
      [function_call, function_call],
      key: ::NearApi::Key.new(@contract_name, key_pair: @key_pair)
    ).call
    render 'call'
  end

  private

  def save_values
    cookies[:contract_name] = params[:contract_name] if params[:contract_name].present?
    cookies[:key_pair] = params[:key_pair] if params[:key_pair].present?
  end

  def error!(message)
    redirect_to counter_path, notice: message
  end

  def function_call
    NearApi::Actions::FunctionCall.new(
      'increment',
      '{}',
      gas: 30_000_000_000_000,
      amount: 0
    )
  end
end
