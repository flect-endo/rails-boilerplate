class SessionsController < Devise::SessionsController
  # API 経由でのログイン時、認証トークンがなければ作る
  # def create
  #   super do |resource|
  #     resource.ensure_authentication_token if request.format.json?
  #   end
  # end
end
