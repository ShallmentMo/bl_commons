# frozen_string_literal: true

module BlCommons
  module RequireSyncConcern
    extend ActiveSupport::Concern

    included do
      def bl_require_sync(node, path, params)
        BlCommons::RequireSyncJob.perform_later(node.to_s, path.to_s, params)
      end
    end
  end
end
