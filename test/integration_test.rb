require 'test_helper'
require 'root/root_v2_api'
require 'smart_proxy_hdm'

# Test that the plugin loads and the Smart Proxy reports the correct feature
class HdmFeaturesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Proxy::PluginInitializer.new(Proxy::Plugins.instance).initialize_plugins
    Proxy::RootV2Api.new
  end

  def load_config(*args, **kwargs)
    Proxy::DefaultModuleLoader.any_instance.expects(:load_configuration_file).with('hdm.yml').returns(*args, **kwargs)
  end

  def failed_module_log
    Proxy::LogBuffer::Buffer.instance.info[:failed_modules][:hdm]
  end

  def get_feature
    get '/features'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    response = JSON.parse(last_response.body)
    feature = response['hdm']
    refute_nil(feature)
    feature
  end

  def test_features
    load_config(enabled: true)

    feature = get_feature

    assert_equal('running', feature['state'], failed_module_log)
    # https://theforeman.org/2019/04/smart-proxy-capabilities-explained.html
    assert_empty(feature['settings'], 'There are no exposed settings')
    assert_empty(feature['capabilities'], 'There are no exposed capabilities')
  end
end
