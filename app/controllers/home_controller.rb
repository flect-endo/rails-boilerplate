class HomeController < ApplicationController
  # before_action :authenticate_user!

  protect_from_forgery except: :index_auth

  def index
  end

  def index_auth
    secret = Rails.application.secrets.client_secret
    signed_request = Restforce.decode_signed_request(params[:signed_request], secret)

    session[:signed_request] = signed_request
    user = User.find_or_create_with_signed_request(signed_request)
    logger.info "logged in from Force.com Canvas"
    logger.info user
    sign_in_and_redirect user

    # redirect_to home_index_url
  end
end
