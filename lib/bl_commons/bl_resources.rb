# frozen_string_literal: true

module BlCommons
  module BlResources
    mattr_accessor :registered_nodes
    self.registered_nodes = {}

    def self.register(name, options = { host: '' })
      registered_nodes[name] = Class.new(ResourceClient).new(options)

      define_singleton_method name do
        registered_nodes[name]
      end
    end
  end
end
