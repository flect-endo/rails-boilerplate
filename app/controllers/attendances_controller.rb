class AttendancesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user

  def index
    @attendances = @user.attendances.includes(:time_entries)
  end

  def clock_in
    Attendance.clock_in(@user)
    respond_to do |format|
      format.html { redirect_to index_url, notice: 'Operation for staring work was successfully done.' }
      format.json { head :ok }
    end
  end

  def clock_out
    Attendance.clock_out(@user)
    respond_to do |format|
      format.html { redirect_to index_url, notice: 'Operation for ending work was successfully done.' }
      format.json { head :ok }
    end
  end

  def destroy
    date = Date.strptime(params[:date], "%Y-%m-%d") rescue nil
    Attendance.where(user: @user, date: date).delete_all
    respond_to do |format|
      format.html { redirect_to index_url, notice: 'User attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def index_url
      url_for(user_id: @user, action: 'index')
    end
end
