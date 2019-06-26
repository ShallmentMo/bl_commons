# frozen_string_literal: true

module BlCommons
  module RemoteAttributesConcern
    extend ActiveSupport::Concern

    class_methods do
      def bl_remote_attributes(options)
        name = options.fetch(:name, model_name.plural)
        foreign_key = options.fetch(:foreign_key, "#{model_name.singular}_id")
        attributes = options.fetch(:attributes, [])
        node = options.fetch(:node)
        prefix = options.fetch(:prefix, '')
        query = options.fetch(:query, {})

        delegator = prefix.present? ? prefix : name
        full_name = "bl_remote_delegator_#{delegator}"

        define_method full_name do
          if instance_variable_get("@#{full_name}")
            return instance_variable_get("@#{full_name}")
          end

          query_options = { attributes: attributes }
          query_options = query_options.merge(query.call(self)) if query.present?
          resp = BlCommons::BlResources.public_send(node).fetch("/#{name}", query_options)

          raise "节点不存在该数据" if resp[0].blank?
          instance_variable_set("@#{full_name}", OpenStruct.new(resp[0].transform_values! { |v| YAML.load(v) }))
        end

        delegate(*attributes, to: full_name, prefix: prefix)
      end
    end
  end
end
