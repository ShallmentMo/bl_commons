require_relative 'bl_resources'
require_relative 'bl_resources/resource_client'

module BlCommons
  class Engine < ::Rails::Engine
    isolate_namespace BlCommons
  end
end
