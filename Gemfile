source 'https://rubygems.org'

gemspec

group :development do
  gem 'debug'
  gem 'rack-test'
  gem 'smart_proxy', github: 'theforeman/smart-proxy'
  gem 'webrick'
  gem 'webmock'
end

group :release, optional: true do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.16.4', require: false
end
