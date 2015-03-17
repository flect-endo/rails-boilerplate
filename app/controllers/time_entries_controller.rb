class TimeEntriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user
  before_action :set_attendance

  def start
    @attendance.time_entries.create!(started_at: Time.current)
    respond_to do |format|
      format.html { redirect_to index_url, notice: 'Operation for staring task was successfully done.' }
      format.json { head :ok }
    end
  end

  def finish
    entry = @attendance.time_entries.order("started_at DESC").first
    if entry.present? and entry.ended_at.nil?
      entry.update_attributes!(ended_at: Time.current)
      option = { notice: 'Operation for finishing task was successfully done.' }
    else
      option = { alert: 'Not started or Already finished.' }
    end

    respond_to do |format|
      format.html { redirect_to index_url, option }
      format.json { head :ok }
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_attendance
      @attendance = Attendance.where(user: @user, date: Date.today).first
    end

    def index_url
      url_for(user_id: @user, controller: 'attendances', action: 'index')
    end
end
