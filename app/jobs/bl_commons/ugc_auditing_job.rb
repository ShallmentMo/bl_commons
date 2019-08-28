# frozen_string_literal: true

module BlCommons
  class UGCAuditingJob < ApplicationJob
    def perform(model, id, action)
      model = model.constantize
      resource = model.find(id)

      resource.public_send(action) if resource
    end
  end
end
