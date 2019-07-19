# frozen_string_literal: true

module BlCommons
  module DeviseForeignSerializeConcern
    extend ActiveSupport::Concern

    class_methods do
      # devise/models/authenticatable.rb
      def serialize_from_session(key, salt)
        foreign_key = "#{model_name.singular}_id"
        record = find_by(foreign_key => key)
        record if record && (record.encrypted_password.blank? || record.authenticatable_salt == salt)
      end

      # devise/models/rememberable.rb
      def serialize_from_cookie(*args)
        id, token, generated_at = *args

        foreign_key = "#{model_name.singular}_id"
        record = find_by(foreign_key => id)
        record if record && record.remember_me?(token, generated_at)
      end
    end
  end
end
