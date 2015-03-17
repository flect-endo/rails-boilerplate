class UserChecklistsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user

  def index
    @checklist_report = @user.user_checklists.includes(:checklist).group_by { |item| item.datetime }
  end

  def new
    @checklists = Checklist.all
  end

  def create
    checklists = Checklist.all
    # 画面上でチェックした項目IDだけが渡ってくる
    checked_ids = params[:user][:user_checklists].reject(&:blank?).map { |id| id.to_i }
    checked_items, unchecked_items = checklists.partition {|item| checked_ids.include? item.id }

    now = Time.at(Time.current.to_i)
    @user.user_checklists << checked_items.map {|item| UserChecklist.new(user: @user, checklist: item, datetime: now, checked: true) }
    @user.user_checklists << unchecked_items.map {|item| UserChecklist.new(user: @user, checklist: item, datetime: now, checked: false) }

    respond_to do |format|
      format.html { redirect_to user_user_checklists_url, notice: 'User checlists were successfully updated.' }
      format.json { head :no_content }
    end
  end

  def destroy
    datetime = Time.strptime(params[:datetime], "%Y-%m-%d-%H-%M-%S") rescue nil
    UserChecklist.where(user: @user, datetime: datetime).delete_all
    respond_to do |format|
      format.html { redirect_to user_user_checklists_url, notice: 'User checlists were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end
end
