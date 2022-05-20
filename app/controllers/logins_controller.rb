# frozen_string_literal: true

class LoginsController < ApplicationController
  def show
  end

  def create
    redirect_to login_path
    return unless params[:signature] && params[:public_key] && params[:account_id]

    signature = NearApi::Base58.decode(params[:signature])
    public_key = params[:public_key]
    account_id = params[:account_id]
    verify_key = Ed25519::VerifyKey.new(NearApi::Base58.decode(public_key))
    raise 'invalid signature' unless verify_key.verify(signature, account_id)

    key_response = NearApi::Api.new.view_access_key(NearApi::Key.new(account_id, public_key: public_key))
    raise 'missing key' if key_response['result']['permission'].blank?

    user = User.find_or_create_by!(account_id: account_id)
    sign_in(user)
  end
end
