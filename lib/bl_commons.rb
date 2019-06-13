# frozen_string_literal: true

require 'bl_commons/engine'

module BlCommons
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
