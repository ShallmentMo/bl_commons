# frozen_string_literal: true

module BlCommons
  module BlResources
    mattr_accessor :registered_nodes, :auth_realm, :auth_username, :auth_password
    self.registered_nodes = {}

    def self.md5_auth_password(password)
      Digest::MD5.hexdigest([
        auth_username,
        password
      ].join(':'))
    end

    def self.register(name, options = { host: '' })
      registered_nodes[name] = Class.new(ResourceClient).new(options.merge({ name: name }))

      define_singleton_method name do
        registered_nodes[name]
      end
    end

    def self.set_attributes(object, params)
      params.each do |k, v|
       next if !object.respond_to?(:"#{k}=") || k == 'id'

       object.send(:"#{k}=", v)
      end
    end
  end
end
