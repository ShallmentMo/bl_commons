# frozen_string_literal: true

require 'bl_commons/bl_resources/missing_resource_publisher'

module BlCommons
  module MissingResourceSubscriberConcern
    extend ActiveSupport::Concern

    included do
      # constants

      # concerns

      # attr related macros

      # association macros

      # validation macros

      # callbacks

      # other macros

      # scopes

      # class methods

      # instance methods
    end

    class_methods do
      def bl_missing_resource_subscribe(resource_name, method_name)
        BlCommons::BlResources::MissingResourcePublisher.subscribe(resource_name, self, method_name)
      end
    end
  end
end
