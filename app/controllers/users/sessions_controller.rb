class Users::SessionsController < Devise::SessionsController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_with_omniauth(auth)

    # アクセストークンを取得する
    # auth["credentials"]["token"]
    # auth["credentials"]["instance_url"]

    sign_in_and_redirect user
  end

  # API 経由でのログイン時、認証トークンがなければ作る
  def create
    super do |resource|
      resource.ensure_authentication_token if request.format.json?
    end
  end
end
