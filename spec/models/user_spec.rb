require 'rails_helper'

RSpec.describe User, type: :model do

  let(:valid_auth) {
    {
      "provider" => "salesforce",
      "uid" => "1234567890",
      "info" => {
        "email" => "user@flect.co.jp",
        "name" => "hoge",
        "nickname" => "hoge"
      }
    }
  }

  let(:valid_signed_request) {
    {
      "context" => {
        "user" => {
          "userName" => "user@flect.co.jp",
          "userId" => "001"
        },
        "organization" => {
          "organizationId" => "flect"
        },
        "links" => {
          "loginUrl" => "http://rspec.salesforce.com/"
        }
      }
    }
  }

  describe "作業記録" do
    let(:now) { Time.local(2015, 3, 13, 12, 0, 0) }
    let(:today) { Date.new(2015, 3, 13) }
    before {
      Time.stub(:current).and_return(now)
      Date.stub(:today).and_return(today)
    }

    describe "作業開始" do
      context "未開始時" do
        let(:user) { create(:user) }
        subject {
          user.start_work
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql now }
        its(:ended_at) { is_expected.to be_nil }
      end

      context "開始済み" do
        let(:user) { create(:user) }
        before {
          Attendance.create(user: user, date: today, started_at: Time.local(2015, 3, 13, 9, 0, 0))
        }
        subject {
          user.start_work
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql Time.local(2015, 3, 13, 9, 0, 0) }
        its(:ended_at) { is_expected.to be_nil }
      end
    end

    describe "作業終了" do
      context "開始済み" do
        let(:user) { create(:user) }
        before {
          Attendance.create(user: user, date: today, started_at: Time.local(2015, 3, 13, 9, 0, 0))
        }
        subject {
          user.end_work
        }
        its(:date) { is_expected.to eql today }
        its(:started_at) { is_expected.to eql Time.local(2015, 3, 13, 9, 0, 0) }
        its(:ended_at) { is_expected.to eql now }
      end
    end
  end

  describe "OAuth経由でのSalesforceログイン時" do
    context "標準フォームから作成された既存ユーザがいる場合" do
      before {
        @user = create(:user)
      }

      subject {
        User.find_or_create_with_omniauth(valid_auth)
      }

      its(:id) { is_expected.to eq @user.id }
      its(:provider) { is_expected.to eq "salesforce" }
      its(:uid) { is_expected.to eq "1234567890"}
    end

    context "既存ユーザがいない場合" do
      subject {
        User.find_or_create_with_omniauth(valid_auth)
      }

      it { expect(subject.persisted?).to be_truthy }
      its(:email) { is_expected.to eq "user@flect.co.jp" }
      its(:provider) { is_expected.to eq "salesforce" }
      its(:uid) { is_expected.to eq "1234567890"}
    end
  end

  describe "署名付き要求経由でのSalesforceログイン時" do
    context "標準フォームから作成された既存ユーザがいる場合" do
      before {
        @user = create(:user)
      }

      subject {
        User.find_or_create_with_signed_request(valid_signed_request)
      }

      its(:id) { is_expected.to eq @user.id }
      its(:provider) { is_expected.to eq "salesforce" }
      its(:uid) { is_expected.to eq "http://rspec.salesforce.com/id/flect/001" }
    end

    context "既存ユーザがいない場合" do
      subject {
        User.find_or_create_with_signed_request(valid_signed_request)
      }

      it { expect(subject.persisted?).to be_truthy }
      its(:email) { is_expected.to eq "user@flect.co.jp" }
      its(:provider) { is_expected.to eq "salesforce" }
      its(:uid) { is_expected.to eq "http://rspec.salesforce.com/id/flect/001" }
    end
  end
end