class HomeController < ApplicationController
  def index
    @team_members_count = SlackUser.available.count
    @other_channels = SlackChannel.available.popular.to_a
    @channels_count = @other_channels.size
    @popular_channels = @other_channels.slice!(0, 6)
    @timezones = SlackUser.tz_offset_distribution
  end
end
