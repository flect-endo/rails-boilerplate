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