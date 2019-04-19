# frozen_string_literal: true

module BlCommons
  module UserRoleConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :role, optional: true
      after_create :create_role
      after_save :update_permissions, if: -> { role && saved_change_to_is_admin? }
    end

    def role_permissions
      role = self.role || Role.new
      permitted_resources(role.permissions)
    end

    def update_permissions
      role.update(permissions_attributes: set_role_permissions)
    end

    def create_role
      role = Role.create(
        name: "超级管理员",
        permissions_attributes: set_role_permissions
      )
      self.update_columns(role_id: role.id)
    end

    def set_role_permissions
      default_permissions = Role.new.permissions.to_h
      default_permissions = set_all_permissions_to_true(default_permissions) if is_admin
      default_permissions
    end

    # 超级管理员可以管理所有的权限
    def set_all_permissions_to_true(permissions)
      permissions_to_true = {}
      permissions.each do |key, values|
        if values.is_a?(Hash)
          permissions_to_true[key] = set_all_permissions_to_true(permissions[key])
        else
          permissions_to_true[key] = true
        end
      end
      permissions_to_true
    end

    def permitted_resources(permissions)
      formated_permissions = []
      if permissions.class.attribute_names_for_inlining.any?
        formated_permissions << {
          label: permissions.class.model_name.human,
          name: permissions.class.model_name.singular,
          actions: permissions.class.attribute_names_for_inlining.map do |permission|
            {
              label: permissions.class.human_attribute_name(permission),
              name: permission,
              value: permissions.public_send(permission)
            }
          end
        }
      end

      permissions.class.attribute_names_for_nesting.each do |permission|
        formated_permissions.concat(permitted_resources(permissions.send(permission)))
      end

      formated_permissions
    end
  end
end
