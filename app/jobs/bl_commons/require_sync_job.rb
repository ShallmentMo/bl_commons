# frozen_string_literal: true

module BlCommons
  class RequireSyncJob < ApplicationJob
    def perform(node, path, params)
      BlCommons::BlResources.public_send(node).require_sync(path, params)
    end
  end
end
