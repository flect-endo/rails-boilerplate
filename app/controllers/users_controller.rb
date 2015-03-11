class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user, only: [:show, :destroy, :index_checklists, :new_checklists, :create_checklists]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # DELETE /users/1
  # DELETE /usres/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def index_checklists
  end

  def new_checklists
    @checklists = Checklist.all
  end

  def create_checklists
    checklists = Checklist.all
    # 画面上でチェックした項目IDだけが渡ってくる
    checked_ids = params[:user][:user_checklists]
    checked_items, unchecked_items = checklists.partition {|item| checked_ids.include? item.id.to_s }

    now = Time.now
    @user.user_checklists.clear
    @user.user_checklists << checked_items.map {|item| UserChecklist.new(user: @user, checklist: item, date: now, checked: true) }
    @user.user_checklists << unchecked_items.map {|item| UserChecklist.new(user: @user, checklist: item, date: now, checked: false) }

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User checlists were successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
