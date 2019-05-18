# frozen_string_literal: true

module BlCommons
  module BlResources
    class MissingResourcePublisher
      cattr_accessor :subscribers
      self.subscribers = {}

      def self.subscribe(resource_name, klass, method_name)
        subscribers[resource_name.to_sym] ||= []
        subscribers[resource_name.to_sym].push([klass, method_name.to_sym])
      end

      def self.publish(resource_name, options)
        subscribers.dig(resource_name.to_sym)&.each do |klass, method_name|
          klass.public_send(method_name, options)
        end
      end
    end
  end
end
