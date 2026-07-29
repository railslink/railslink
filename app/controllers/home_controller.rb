class HomeController < ApplicationController
  # These two aggregates scan the whole users table (~23k rows) and were being
  # recomputed on every anonymous hit. They only change when the Slack sync or an
  # event job runs, so a short TTL is plenty. Channels are left uncached — there
  # are ~42 of them, the lookup is indexed, and the view mutates the collection.
  CACHE_TTL = 15.minutes

  def index
    @team_members_count = Rails.cache.fetch("home/team_members_count", expires_in: CACHE_TTL) do
      SlackUser.available.count
    end
    @timezones = Rails.cache.fetch("home/timezones", expires_in: CACHE_TTL) do
      SlackUser.tz_offset_distribution
    end

    @other_channels = SlackChannel.available.popular.to_a
    @channels_count = @other_channels.size
    @popular_channels = @other_channels.slice!(0, 6)
  end
end
