class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user, except: [:index]

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

  def index_attendances
    @attendances = @user.attendances
  end

  def index_checklists
    @checklist_report = @user.user_checklists.includes(:checklist).group_by { |item| item.datetime }
  end

  def start_work
    @user.start_work
  end

  def end_work
    @user.end_work
  end

  def new_checklists
    @checklists = Checklist.all
  end

  def create_checklists
    checklists = Checklist.all
    # 画面上でチェックした項目IDだけが渡ってくる
    checked_ids = params[:user][:user_checklists].reject(&:blank?).map { |id| id.to_i }
    checked_items, unchecked_items = checklists.partition {|item| checked_ids.include? item.id }

    now = Time.at(Time.current.to_i)
    @user.user_checklists << checked_items.map {|item| UserChecklist.new(user: @user, checklist: item, datetime: now, checked: true) }
    @user.user_checklists << unchecked_items.map {|item| UserChecklist.new(user: @user, checklist: item, datetime: now, checked: false) }

    respond_to do |format|
      format.html { redirect_to checklists_user_url, notice: 'User checlists were successfully updated.' }
      format.json { head :no_content }
    end
  end

  def destroy_checklists
    datetime = Time.strptime(params[:datetime], "%Y-%m-%d-%H-%M-%S") rescue nil
    UserChecklist.where(user: @user, datetime: datetime).delete_all
    respond_to do |format|
      format.html { redirect_to checklists_user_url, notice: 'User checlists were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
