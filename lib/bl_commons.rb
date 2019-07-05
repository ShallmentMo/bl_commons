# frozen_string_literal: true

require 'bl_commons/engine'

module BlCommons
  LOGISTIC_COMPANY_MAPPINGS = {
    '邮政包裹/平邮' => 'youzhengguonei',
    '邮政国际包裹' => 'youzhengguoji',
    'EMS' => 'ems',
    '顺丰' => 'shunfeng',
    '申通' => 'shentong',
    '圆通' => 'yuantong',
    '中通' => 'zhongtong',
    '汇通' => 'huitongkuaidi',
    '韵达' => 'yunda',
    '宅急' => 'zhaijisong',
    '天天' => 'tiantian',
    '德邦' => 'debangwuliu',
    '国通' => 'guotongkuaidi',
    '中铁物流' => 'zhongtiewuliu',
    '中铁快运' => 'ztky',
    '能达' => 'ganzhongnengda',
    '优速' => 'youshuwuliu',
    '全峰' => 'quanfengkuaidi',
    '京东' => 'jd'
  }.freeze
  LOGISTIC_COMPANIES = LOGISTIC_COMPANY_MAPPINGS.keys.freeze

  def self.redis
    return @redis if @redis

    redis_url = Rails.application.secrets[:redis_url]
    redis_password = Rails.application.secrets.redis[:password]

    @redis = Redis::Namespace.new(
      :bl_commons,
      redis: Redis.new(url: redis_url, password: redis_password)
    )
  end

  def self.available_locales
    return [I18n.default_locale.to_s] unless redis.get('available_locales')

    JSON.parse(redis.get('available_locales'))
  end

  def self.available_locales=(array)
    redis.set('available_locales', array)
  end
end
