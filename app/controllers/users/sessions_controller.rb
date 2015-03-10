require 'restforce'

class Users::SessionsController < Devise::SessionsController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_with_omniauth(auth)

    session[:restforce] = Restforce.new(
      oauth_token: auth["credentials"]["token"],
      refresh_token: auth["credentials"]["refresh_token"],
      instance_url: auth["credentials"]["instance_url"],
      client_id: Rails.application.secrets.client_key,
      client_secret: Rails.application.secrets.client_secret
    )

    sign_in_and_redirect user
  end

  # API 経由でのログイン時、認証トークンがなければ作る
  def create
    super do |resource|
      resource.ensure_authentication_token if request.format.json?
    end
  end
end
