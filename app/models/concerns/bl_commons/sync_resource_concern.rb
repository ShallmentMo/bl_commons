# frozen_string_literal: true

module BlCommons
  module SyncResourceConcern
    extend ActiveSupport::Concern

    included do
      # constants

      # concerns

      # attr related macros
      cattr_accessor(
        :bl_sync_resource_name,
        :bl_sync_resource_foreign_key,
        :bl_sync_resource_attributes,
        :bl_sync_resource_node_names
      )

      # association macros

      # validation macros

      # callbacks
      after_commit :bl_sync_resource, if: -> { bl_sync_resource? }

      # other macros

      # scopes

      # class methods

      # instance methods
      private

      def bl_sync_resource_nodes
        bl_sync_resource_node_names.map do |name|
          BlCommons::BlResources.public_send(name)
        end
      end

      def bl_sync_resource?
        bl_sync_resource_attributes.any? do |attribute|
          saved_change_to_attribute?(attribute)
        end
      end

      def bl_sync_resource
        BlCommons::SyncResourceJob.perform_later(model_name.name, id)
      end

      def bl_sync_resource_params
        bl_sync_resource_attributes.each_with_object({}) do |key, memo|
          memo[key] = public_send(key)
        end
      end
    end

    class_methods do
      def bl_sync_resource(options)
        self.bl_sync_resource_name =
          options.fetch(:name, model_name.plural)
        self.bl_sync_resource_foreign_key =
          options.fetch(:foreign_key, "#{model_name.singular}_id")
        self.bl_sync_resource_attributes =
          options.fetch(:attributes, [])
        self.bl_sync_resource_node_names = options.fetch(:nodes, [])
      end
    end
  end
end
