module Proxy
  module Hdm
    class Api < ::Sinatra::Base
      helpers ::Proxy::Helpers

      # Require authentication
      authorize_with_trusted_hosts
      authorize_with_ssl_client

      get '/nodes/:node/keys' do |n|
        get_from_hdm("/api/v1/nodes/#{n}/keys")
      end

      get '/nodes/:node/keys/:key' do |n, k|
        get_from_hdm("/api/v1/nodes/#{n}/keys/#{k}")
      end

      get '/environments/:environment/nodes/:node/keys' do |e, n|
        get_from_hdm("/api/v1/environments/#{e}/nodes/#{n}/keys")
      end

      get '/environments/:environment/nodes/:node/keys/:key' do |e, n, k|
        get_from_hdm("/api/v1/environments/#{e}/nodes/#{n}/keys/#{k}")
      end

      private

      def get_from_hdm(path)
        content_type :json
        begin
          result = perform_request(path)
          return result.body if result.is_a?(Net::HTTPSuccess)

          log_halt result.code.to_i, "HDM server at #{hdm_uri} returned an error: '#{result.message}'"
        rescue SocketError, Errno::ECONNREFUSED => e
          log_halt 503, "Communication error with '#{hdm_uri.host}': #{e.message}"
        end
      end

      def perform_request(path)
        req = Net::HTTP::Get.new(URI.join("#{hdm_uri.to_s.chomp('/')}/", path))
        req['Accept'] = 'application/json'
        req.basic_auth Plugin.settings.hdm_user, Plugin.settings.hdm_password
        http.request(req)
      end

      def http
        http = Net::HTTP.new(hdm_uri.host, hdm_uri.port)
        http.use_ssl = hdm_uri.scheme == 'https'
        http
      end

      def hdm_uri
        @hdm_uri ||= URI.parse(Plugin.settings.hdm_url.to_s)
      end
    end
  end
end
