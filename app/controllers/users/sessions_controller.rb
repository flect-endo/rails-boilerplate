class Users::SessionsController < Devise::SessionsController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth["provider"], uid: auth["uid"]).first || User.create_with_omniauth(auth)
    sign_in_and_redirect user
  end

  # API 経由でのログイン時、認証トークンがなければ作る
  def create
    super do |resource|
      resource.ensure_authentication_token if request.format.json?
    end
  end
end
