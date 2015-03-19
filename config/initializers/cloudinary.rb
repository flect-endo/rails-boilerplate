# Cloudinary の設定。
# 最低限必要なパラメータは　cloud_name, api_key, api_secret の3つ。
# ただしこれらのパラメータは CLOUDINARY_URL 環境変数がセットされている場合、自動で行われる。
# なので、この initializer 自体が不要かもしれないが、他のパラメータを設定したい時に
# 備えて定義しておく。
# http://cloudinary.com/documentation/rails_additional_topics#configuration_options
Cloudinary.config do |config|
  if Rails.application.secrets.cloudinary_url.blank?
    p "'CLOUDINARY_URL' environment variable is not set."
  end

  conf = (
    /cloudinary:\/\/
    (?<api_key> [a-z0-9]+)
    :
    (?<api_secret> [a-zA-Z0-9\-_]+)
    @
    (?<cloud_name> [a-z]+)
    /x.match(Rails.application.secrets.cloudinary_url) || { cloud_name: "", api_key: "", api_secret: "" })

  config.cloud_name = conf[:cloud_name]
  config.api_key = conf[:api_key]
  config.api_secret = conf[:api_secret]
end