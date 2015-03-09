class HomeController < ApplicationController
  # before_action :authenticate_user!

  protect_from_forgery except: :index_auth

  def index
  end

  def index_auth
    secret = Rails.application.secrets.client_secret
    # session[:signed_request] =
    decoded = Restforce.decode_signed_request(params[:signed_request], secret)
    logger.info "*********************************1"
    logger.info decoded
    logger.info "*********************************2"
    logger.info decoded.length
    session[:signed_request] = decoded
    redirect_to home_index_url
  end
end
