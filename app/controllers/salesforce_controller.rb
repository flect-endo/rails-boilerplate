class SalesforceController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def credentials
    render json: (session[:credentials] || {}).to_json
  end
end
