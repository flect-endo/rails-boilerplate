require 'rails_helper'

RSpec.describe Attendance, type: :model do

  describe "出退勤" do
    let(:now) { Time.local(2015, 3, 13, 12, 0, 0) }
    let(:today) { Date.new(2015, 3, 13) }
    before {
      Time.stub(:current).and_return(now)
      Date.stub(:today).and_return(today)
    }

    describe "clock_in" do
      context "未開始時" do
        let(:user) { create(:user) }
        subject {
          Attendance.clock_in(user)
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql now }
        its(:ended_at) { is_expected.to be_nil }
      end

      context "開始済み" do
        let(:user) { create(:user) }
        before {
          Attendance.create!(user: user, date: today, started_at: Time.local(2015, 3, 13, 9, 0, 0))
        }
        subject {
          Attendance.clock_in(user)
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql Time.local(2015, 3, 13, 9, 0, 0) }
        its(:ended_at) { is_expected.to be_nil }
      end
    end

    describe "clock_out" do
      context "開始済み" do
        let(:user) { create(:user) }
        before {
          Attendance.create!(user: user, date: today, started_at: Time.local(2015, 3, 13, 9, 0, 0))
        }
        subject {
          Attendance.clock_out(user)
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql Time.local(2015, 3, 13, 9, 0, 0) }
        its(:ended_at) { is_expected.to eql now }
      end
    end
  end
end
