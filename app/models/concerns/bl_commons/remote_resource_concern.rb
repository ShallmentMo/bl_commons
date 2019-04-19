# frozen_string_literal: true

module BlCommons
  module RemoteResourceConcern
    extend ActiveSupport::Concern

    included do
      # constants

      # concerns

      # attr related macros
      cattr_accessor(
        :bl_remote_resource_name,
        :bl_remote_resource_foreign_key,
        :bl_remote_resource_attributes,
        :bl_controllable_remote_resource_attributes,
        :bl_remote_resource_node_name
      )

      # association macros

      # validation macros

      # callbacks
      before_validation :create_bl_remote_resource, on: :create
      before_update :update_bl_remote_resource
      after_destroy :destroy_bl_remote_resource

      # other macros

      # scopes

      # class methods

      # instance methods
      def bl_remote_resource
        return @bl_remote_resource if @bl_remote_resource

        object = bl_remote_resource_node.fetch("/#{bl_remote_resource_name}/#{public_send(bl_remote_resource_foreign_key)}", attributes: bl_remote_resource_attributes)

        @bl_remote_resource = object ? OpenStruct.new(bl_remote_resource_transform_values!(object)) : nil
      end

      def bl_remote_resource=(object)
        @bl_remote_resource = object ? OpenStruct.new(bl_remote_resource_transform_values!(object)) : nil
      end

      private

      def bl_remote_resource_transform_values!(object)
        object.transform_values! { |v| YAML.load(v) }
      end

      def bl_remote_resource_node
        BlCommons::BlResources.public_send(bl_remote_resource_node_name)
      end

      def bl_remote_resource_params
        bl_controllable_remote_resource_attributes.each_with_object({}) do |key, memo|
          memo[key] = public_send(key)
        end
      end

      def create_bl_remote_resource
        return if public_send(bl_remote_resource_foreign_key)
        return if bl_controllable_remote_resource_attributes.empty?

        resp = bl_remote_resource_node.create(
          "/#{bl_remote_resource_name}",
          resource_params: bl_remote_resource_params,
          attributes: bl_remote_resource_attributes + %i[id]
        )

        if resp['error_message']
          errors.add(:base, '创建资源失败')
        else
          public_send("#{bl_remote_resource_foreign_key}=", resp['id'])
          self.bl_remote_resource = resp.as_json
        end
      end

      def update_bl_remote_resource
        return unless public_send(bl_remote_resource_foreign_key)
        return if bl_controllable_remote_resource_attributes.empty?

        resp = bl_remote_resource_node.update(
          "/#{bl_remote_resource_name}/#{public_send(bl_remote_resource_foreign_key)}",
          resource_params: bl_remote_resource_params,
          attributes: bl_remote_resource_attributes
        )

        if resp['error_message']
          errors.add(:base, '修改资源失败')
        else
          self.bl_remote_resource = resp.as_json
        end
      end

      def destroy_bl_remote_resource
        resp = bl_remote_resource_node.destroy("/#{bl_remote_resource_name}/#{public_send(bl_remote_resource_foreign_key)}")

        if resp['error_message']
          errors.add(:base, '删除资源失败')
        else
          self.bl_remote_resource = resp.as_json
        end
      end
    end

    class_methods do
      def bl_remote_resource(options)
        self.bl_remote_resource_name =
          options.fetch(:name, model_name.plural)
        self.bl_remote_resource_foreign_key =
          options.fetch(:foreign_key, "#{model_name.singular}_id")
        self.bl_remote_resource_attributes =
          options.fetch(:attributes, [])
        self.bl_controllable_remote_resource_attributes =
          options.fetch(:controllable_attributes, [])
        self.bl_remote_resource_node_name =
          options.fetch(:node)

        attr_accessor *bl_remote_resource_attributes

        bl_remote_resource_attributes.each do |key|
          define_method key do
            instance_variable_get("@#{key}") ||
              (public_send(self.bl_remote_resource_foreign_key) && bl_remote_resource.public_send(key))
          end
        end
      end
    end
  end
end
