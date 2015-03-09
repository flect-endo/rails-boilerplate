class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    logger.info "-------------------------------------------------"
    request.headers.each {|k, v| logger.info k}
  end
end
