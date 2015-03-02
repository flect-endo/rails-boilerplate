class UsersController < ApplicationController
  before_action :set_note, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
