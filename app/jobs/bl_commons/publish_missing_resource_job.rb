# frozen_string_literal: true

require 'bl_commons/bl_resources/missing_resource_publisher'

module BlCommons
  class PublishMissingResourceJob < ApplicationJob
    def perform(resource_name, params)
      BlCommons::BlResources::MissingResourcePublisher.publish(resource_name, { "params" => params })
    end
  end
end
