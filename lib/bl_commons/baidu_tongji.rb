# frozen_string_literal: true
# ref: https://tongji.baidu.com/api/manual/

module BlCommons
  module BaiduTongji
    class << self
      attr_accessor :password , :username, :token, :account_type

      def logger
        @@logger ||= ::Logger.new(Rails.root.join("log", "baidu_tongji.log"))
      end

      def logger=(logger)
        @@logger = logger
      end

      # ref: https://tongji.baidu.com/api/manual/Chapter2/
      def request_header_params
        {
          "account_type": account_type || 1,
          "password": password,
          "token": token,
          "username": username
        }
      end
    end
  end
end
