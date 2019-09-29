# frozen_string_literal: true

# DRDS 不支持嵌套事务，类似 `rollback to savepoint savepoint_name`
require 'aasm/base'

AASM::Base.class_eval do
  alias_method :orig_initialize, :initialize

  def initialize(klass, name, state_machine, options = {}, &block)
    orig_initialize(klass, name, state_machine, options, &block)

    # 如果没有配置 requires_new_transaction，则设置为 false
    unless options.key?(:requires_new_transaction)
      @state_machine.config.requires_new_transaction = false
    end
  end
end
