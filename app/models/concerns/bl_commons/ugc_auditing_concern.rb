# frozen_string_literal: true

module BlCommons
  module UGCAuditingConcern
    extend ActiveSupport::Concern

    included do
      def auto_audit_resource!(action)
        BlCommons::UGCAuditingJob.perform_later(self.class.class_name, self.id, action)
      end
    end
  end
end
