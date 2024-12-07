require File.expand_path('lib/smart_proxy_hdm/version', __dir__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'smart_proxy_hdm'
  s.version     = Proxy::Hdm::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.authors     = ['betadots GmbH']
  s.email       = ['info@betadots.de']
  s.homepage    = 'https://github.com/betadots/smart_proxy_hdm'

  s.summary     = "An HDM Plugin for Foreman's smart proxy"
  s.description = 'Read hiera data via HDM to display alongside hosts in Foreman'

  s.files       = Dir['{config,lib,bundler.d}/**/*'] + ['README.md', 'LICENSE']
  s.test_files  = Dir['test/**/*']

  s.required_ruby_version = Gem::Requirement.new('>= 2.7')

  s.add_development_dependency 'minitest', '~> 5.18'
  s.add_development_dependency 'mocha', '~> 2.0', '>= 2.0.4'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  s.add_development_dependency 'rubocop', '~> 1.52', '>= 1.52.1'
  s.add_development_dependency 'rubocop-minitest', '~> 0.33.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.18'
  s.add_development_dependency 'rubocop-rails', '~> 2.19', '>= 2.19.1'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
end
