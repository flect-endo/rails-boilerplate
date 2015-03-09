class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    logger.info "request headers -------------------------------------------------"
    request.headers.each {|k, v| logger.info k}
    logger.info "params ----------------------------------------------------------"
    logger.info params
  end
end
