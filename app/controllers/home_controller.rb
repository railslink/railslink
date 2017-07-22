class HomeController < ApplicationController
  
  def index
    
    # Cache everything for a day to avoid DB hit and try to stay under heroku memory limits
    @team_members_count, @channels, @timezones = cache(Date.today) do
      [
        SlackApiResponse.members.size,
        SlackApiResponse.popular_channels,
        SlackApiResponse.tz_distribution
      ]
    end
  end

end
