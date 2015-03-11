require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  login_admin

  describe "Get #index" do
    before { get :index }
    it { expect(response).to be_success }
  end
end
