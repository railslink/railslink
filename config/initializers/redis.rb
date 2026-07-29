# REDIS_URL is what config/deploy.yml sets. REDISCLOUD_URL is the Heroku-era name,
# kept only as a fallback for anyone still running against an old .env — reading it
# first meant production silently connected to localhost instead of the
# railslink-redis accessory.
#
# Timeouts are explicit because SlackController publishes to Redis inside the
# request cycle; without them an unreachable Redis holds a Puma thread on the
# default connect timeout for every inbound Slack event.
redis_url = ENV["REDIS_URL"].presence || ENV["REDISCLOUD_URL"].presence

REDIS = Redis.new(
  **{ url: redis_url }.compact,
  connect_timeout: 1,
  read_timeout: 1,
  write_timeout: 1
)
