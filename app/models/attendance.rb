class Attendance < ActiveRecord::Base
  belongs_to :user

  def self.clock_in(user)
    where(user: user, date: Date.today).first \
    || create!(user: user, date: Date.today, started_at: Time.current)
  end

  def self.clock_out(user)
    attendance = Attendance.where(user: user, date: Date.today).first
    raise "not start" if attendance.nil?
    raise "already end" if attendance.ended_at.present?

    attendance.update_attributes!(ended_at: Time.current)
    attendance
  end
end
