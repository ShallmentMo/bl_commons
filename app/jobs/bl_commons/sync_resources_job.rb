# frozen_string_literal: true

module BlCommons
  class SyncResourcesJob < ApplicationJob
    def perform(model_name, ids)
      relation = model_name.constantize.where(id: ids)

      return unless relation.exists?

      relation.in_batches(of: relation.bl_sync_resource_batch_size) do |collection|
        collection.send(:bl_sync_resource_nodes).each do |node|
          resp = node.batch_sync(
            "/#{collection.bl_sync_resource_name}",
            collection: collection.map do |object|
              {
                object.bl_sync_resource_foreign_key.to_s => object.id,
                resource_params: object.send(:bl_sync_resource_params)
              }
            end.to_a
          )

          raise "#{node.name}: 同步 #{model_name} #{ids} 失败，#{resp['error_message']}" if resp['error_message']
        end
      end
    end
  end
end
