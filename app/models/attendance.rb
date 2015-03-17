class Attendance < ActiveRecord::Base
  belongs_to :user
  has_many :time_entries, dependent: :delete_all

  def self.clock_in(user, date=Date.today, started_at=Time.current)
    where(user: user, date: date).first \
    || create!(user: user, date: date, started_at: started_at)
  end

  def self.clock_out(user, date=Date.today, ended_at=Time.current)
    attendance = Attendance.where(user: user, date: date).first
    raise "not start" if attendance.nil?

    attendance.update_attributes!(ended_at: ended_at)
    attendance
  end
end
