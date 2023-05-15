require 'minitest/autorun'
require 'mocha/minitest'
require 'rack/test'
require 'webmock/minitest'

require 'smart_proxy_for_testing'

ENV['RACK_ENV'] = 'test'

# create log directory in our (not smart-proxy) directory
FileUtils.mkdir_p File.dirname(Proxy::SETTINGS.log_file)
