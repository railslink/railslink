class SlackEvent::UnhandledJob < ApplicationJob

  MAX_LIST_SIZE = 100

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
    store_in_redis_list
    prune_redis_list
  end

  private

  def store_in_redis_list
    REDIS.rpush(redis_key, options.to_json)
  end

  def prune_redis_list
    REDIS.ltrim(redis_key, 0, MAX_LIST_SIZE - 1) # zero based
  end

  def redis_key
    "slack_event:unhandled_jobs"
  end
end
