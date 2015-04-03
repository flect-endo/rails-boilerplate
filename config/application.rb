require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsBoilerplate
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir["#{config.root}/app/validators"]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.assets.precompile = config.assets.precompile + %w(*.png *.jpg *.jpeg *.gif *.woff *.ttf *.svg *.eot)

    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    # Cross Domain 対応
    config.middleware.insert_before Warden::Manager, Rack::Cors do
      allow do
        origins '*' # 'localhost:8100'
        resource '*',
          headers: :any,
          methods: [:get, :post, :delete, :put, :options],
          credentials: true,
          max_age: 86400
      end
    end

    # "X-Frame-Options: SAMEORIGIN" レスポンスヘッダによって iframe で view が表示できない対応
    # config.action_dispatch.default_headers['X-Frame-Options'] = "Allow-From https://hoge.com"
    config.action_dispatch.default_headers.delete 'X-Frame-Options'
  end
end
