require 'restforce'

class SalesforceController < ApplicationController
  before_action :authenticate_user!
  before_action :build_client, only: [:index]

  def index
    @accounts = @client.query("select Id, Name, (select Name from Contacts) from Account")
  end

  def credentials
    render json: (session[:credentials] || {}).to_json
  end

  def onload
    @success, @error = params[:success], params[:error]
  end

  private

  def build_client
    # TODO: セッションに認証トークンがない場合(=通常フォームでのログイン)、
    # 本当は例外を投げるようにしたほうがよい
    credentials = session[:credentials] || {}
    @client = Restforce.new(
      oauth_token: credentials[:oauth_token],
      refresh_token: credentials[:refresh_token],
      instance_url: credentials[:instance_url],
      client_id: Rails.application.secrets.client_key,
      client_secret: Rails.application.secrets.client_secret
    )
  end
end
