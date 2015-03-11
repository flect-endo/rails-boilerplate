module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @login_user = FactoryGirl.create(:admin)
      sign_in :user, @login_user
    end
  end
end