require_relative 'version'

module Proxy
  module Hdm
    class Plugin < ::Proxy::Plugin
      plugin :hdm, ::Proxy::Hdm::VERSION
      rackup_path File.expand_path('http_config.ru', __dir__)

      # Settings listed under default_settings are required.
      # An exception will be raised if they are initialized with nil values.
      # Settings not listed under default_settings are considered optional and by default have nil value.
      default_settings hdm_url: 'http://localhost:3000',
        hdm_user: 'api',
        hdm_password: 'api'

      validate :hdm_url, url: true
    end
  end
end
