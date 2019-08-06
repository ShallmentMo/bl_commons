# frozen_string_literal: true

module BlCommons
  class SyncResourceJob < ApplicationJob
    def perform(model_name, id)
      model  = model_name.constantize
      # supporting soft deleted resource
      relation = model.respond_to?(:with_deleted) ? model : model.with_deleted

      object = relation.find_by(id: id)

      return unless object

      object.send(:bl_sync_resource_nodes).each do |node|
        resp = node.sync(
          "/#{object.bl_sync_resource_name}",
          object.bl_sync_resource_foreign_key.to_s => id,
          resource_params: object.send(:bl_sync_resource_params)
        )

        raise "#{node.name}: 同步 #{model_name} #{id} 失败，#{resp['error_message']}" if resp['error_message']
      end
    end
  end
end
