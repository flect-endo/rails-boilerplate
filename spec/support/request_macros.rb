include Warden::Test::Helpers

module RequestMacros
  def login_admin
    before(:each) do
      login_as FactoryGirl.create(:admin), scope: :user, run_callbacks: false
    end
  end
end