require 'smart_proxy_hdm/api'

map '/hdm' do
  run Proxy::Hdm::Api
end
