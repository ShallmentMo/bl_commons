# frozen_string_literal: true

require 'httparty'
require 'persistent_httparty'

module BlCommons
  module BlResources
    class ResourceClient
      include HTTParty
      persistent_connection_adapter

      class_attribute :name

      def initialize(host: '', name: '')
        self.class.digest_auth(
          BlCommons::BlResources.auth_username,
          BlCommons::BlResources.auth_password
        )
        self.class.base_uri "#{host}/bl_resources"
        self.name = name
      end

      def fetch(path, params = {})
        self.class.get(path, body: params, headers: default_headers)
      end

      def create(path, params = {})
        self.class.post(path.to_s, body: params, headers: default_headers)
      end

      def update(path, params = {})
        self.class.put(path.to_s, body: params, headers: default_headers)
      end

      def destroy(path, params = {})
        self.class.delete(path.to_s, body: params, headers: default_headers)
      end

      def sync(path, params = {})
        self.class.post("#{path}/sync", body: params, headers: default_headers)
      end

      def batch_sync(path, params = {})
        self.class.post("#{path}/batch_sync", body: params, headers: default_headers)
      end

      def require_sync(path, params = {})
        self.class.post("#{path}/require_sync", body: params, headers: default_headers)
      end

      def default_headers
        { Locale: I18n.locale.to_s }
      end
    end
  end
end
