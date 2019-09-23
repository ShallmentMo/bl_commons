# frozen_string_literal: true

# Production 环境使用 阿里 DRDS，DRDS 不支持 GET_LOCK 函数
if Rails.env.production?
  require "active_record/connection_adapters/abstract_mysql_adapter"

  module ActiveRecord
    module ConnectionAdapters
      class AbstractMysqlAdapter
        def supports_advisory_locks?
          false
        end
      end
    end
  end
end
