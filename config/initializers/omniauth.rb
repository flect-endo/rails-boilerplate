Rails.application.config.middleware.use OmniAuth::Builder do
  provider :salesforce,
    Rails.application.secrets.client_key,
    Rails.application.secrets.client_secret
end