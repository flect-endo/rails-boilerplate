require 'restforce'

class Users::SessionsController < Devise::SessionsController
  protect_from_forgery except: :index_auth

  # OAuth 認証からのコールバック
  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_with_omniauth(auth)

    store_session(
      auth["credentials"]["token"],
      auth["credentials"]["refresh_token"],
      auth["credentials"]["instance_url"]
    )

    sign_in_and_redirect user
  end

  # Force.com からの署名付き要求受け付け
  def auth_signed_request
    secret = Rails.application.secrets.client_secret
    signed_request = Restforce.decode_signed_request(params[:signed_request], secret)

    store_session(
      signed_request['client']['oauthToken'],
      signed_request['client']['refreshToken'],
      signed_request['client']['instanceUrl']
    )

    user = User.find_or_create_with_signed_request(signed_request)
    sign_in_and_redirect user
  end

  def create
    super do |resource|
      # API 経由でのログイン時に限り、認証トークンがなければ作る
      resource.ensure_authentication_token if request.format.json?
    end
  end

  private

  # 認証情報をセッションに保存する
  def store_session(oauth_token, refresh_token, instance_url)
    session[:credentials] = {
      oauth_token: oauth_token,
      refresh_token: refresh_token,
      instance_url: instance_url
    }
    # セッションに Restforce インスタンスを持つと、
    # require 'restforce" していないコントローラを読み込んだ時に
    # undefiend エラーになることがあるので、とりあえずコメントアウト
    # session[:restforce] = Restforce.new(
    #   oauth_token: oauth_token,
    #   refresh_token: refresh_token,
    #   instance_url: instance_url,
    #   client_id: Rails.application.secrets.client_key,
    #   client_secret: Rails.application.secrets.client_secret
    # )
  end
end
