require_relative 'bl_resources'
require_relative 'bl_resources/resource_client'
require_relative 'baidu_tongji'
require_relative 'baidu_tongji/baidu_tongji_client'

module BlCommons
  class Engine < ::Rails::Engine
    isolate_namespace BlCommons
  end
end
