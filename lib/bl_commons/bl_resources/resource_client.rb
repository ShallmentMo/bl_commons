# frozen_string_literal: true

require 'httparty'

module BlCommons
  module BlResources
    class ResourceClient
      include HTTParty

      def initialize(host: '')
        self.class.base_uri "#{host}/bl_resources"
      end

      def fetch(path, params = {})
        self.class.get(path, body: params)
      end

      def create(path, params = {})
        self.class.post(path.to_s, body: params)
      end

      def update(path, params = {})
        self.class.put(path.to_s, body: params)
      end

      def destroy(path, params = {})
        self.class.delete(path.to_s, body: params)
      end

      def sync(path, params = {})
        self.class.post("#{path}/sync", body: params)
      end
    end
  end
end
