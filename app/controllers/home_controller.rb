class HomeController < ApplicationController
  # before_action :authenticate_user!

  protect_from_forgery except: :index_auth

  def index
  end

  def index_auth
    secret = Rails.application.secrets.client_secret
    session[:signed_request] = Restforce.decode_signed_request(params[:signed_request], secret)
    redirect_to home_index_url
  end
end
