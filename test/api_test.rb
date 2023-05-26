require 'test_helper'
require 'smart_proxy_hdm/api'

# Test that API returns the correct responses
class HdmApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Proxy::Hdm::Api.new
  end

  def setup
    Proxy::Hdm::Plugin.load_test_settings
  end

  def test_keys_index_without_environment
    keys_data = [{"name" => "hdm::float"}, {"name" => "hdm::integer"}]
    stub_request(
      :get,
      "#{::Proxy::Hdm::Plugin.settings.hdm_url}/api/v1/nodes/test.host/keys"
    ).to_return(body: keys_data.to_json)

    get '/nodes/test.host/keys'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert last_response['Content-Type'] == 'application/json'
    response = JSON.parse(last_response.body)
    assert_equal response, keys_data
  end

  def test_key_show_without_environment
    key_data = [{
      "hierarchy_name" => "main",
      "files" => [
        {"path" => "common.yaml", "value" => 2}
      ]
    }]

    stub_request(
      :get,
      "#{::Proxy::Hdm::Plugin.settings.hdm_url}/api/v1/nodes/test.host/keys/hdm::integer"
    ).to_return(body: key_data.to_json)

    get '/nodes/test.host/keys/hdm::integer'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert last_response['Content-Type'] == 'application/json'
    response = JSON.parse(last_response.body)
    assert_equal response, key_data
  end

  def test_keys_index_with_environment
    keys_data = [{"name" => "hdm::float"}, {"name" => "hdm::integer"}]
    stub_request(
      :get,
      "#{::Proxy::Hdm::Plugin.settings.hdm_url}/api/v1/environments/development/nodes/test.host/keys"
    ).to_return(body: keys_data.to_json)

    get '/environments/development/nodes/test.host/keys'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert last_response['Content-Type'] == 'application/json'
    response = JSON.parse(last_response.body)
    assert_equal response, keys_data
  end

  def test_key_show_with_environment
    key_data = [{
      "hierarchy_name" => "main",
      "files" => [
        {"path" => "common.yaml", "value" => 2}
      ]
    }]

    stub_request(
      :get,
      "#{::Proxy::Hdm::Plugin.settings.hdm_url}/api/v1/environments/development/nodes/test.host/keys/hdm::integer"
    ).to_return(body: key_data.to_json)

    get '/environments/development/nodes/test.host/keys/hdm::integer'
    assert last_response.ok?, "Last response was not ok: #{last_response.body}"
    assert last_response['Content-Type'] == 'application/json'
    response = JSON.parse(last_response.body)
    assert_equal response, key_data
  end

  def test_hdm_api_error
    stub_request(
      :get,
      "#{::Proxy::Hdm::Plugin.settings.hdm_url}/api/v1/environments/development/nodes/test.host/keys/unknown"
    ).to_return(status: [404, "Not found"])

    get '/environments/development/nodes/test.host/keys/unknown'

    refute last_response.ok?, "Last response was ok, should have been an error"
    assert_equal 404, last_response.status
    assert_equal "HDM server at http://localhost:3000 returned an error: 'Not found'", last_response.body
  end
end
