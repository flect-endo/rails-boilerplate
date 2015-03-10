require 'restforce'

class HomeController < ApplicationController
  # before_action :authenticate_user!

  protect_from_forgery except: :index_auth

  def index
  end

  def index_auth
    secret = Rails.application.secrets.client_secret
    signed_request = Restforce.decode_signed_request(params[:signed_request], secret)

    # session[:signed_request] = signed_request
    session[:restforce] = Restforce.new(
      oauth_token: signed_request['client']['oauthToken'],
      refresh_token: signed_request['client']['refreshToken'],
      instance_url: signed_request['client']['instanceUrl'],
      client_id: Rails.application.secrets.client_key,
      client_secret: Rails.application.secrets.client_secret
    )

    user = User.find_or_create_with_signed_request(signed_request)
    sign_in_and_redirect user

    # redirect_to home_index_url
  end
end
