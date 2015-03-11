require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  login_admin

  let(:valid_session) { {} }

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "admin2" }
      }

      before {
        put :update, { :user => new_attributes }, valid_session
        @login_user.reload
      }

      subject {
        @login_user
      }

      its(:name) { is_expected.to eq "admin2" }
    end
  end
end