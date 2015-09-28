class HomeController < ApplicationController
  
  def index
    valid_members = SlackApiResponse.latest('users.list').response['members']
      .select{ |u| u['deleted'] == false }
    
    @team_members_count = valid_members.size
    
    @channels = SlackApiResponse.latest('channels.list').response['channels']
      .sort_by{ |c| c['num_members'] }.reverse.first(6)
      
    # @timezones is a hash like 
    # {
    #   'UTC-7': 70,
    #   'UTC-6': 54
    # }
    members_with_tz = valid_members.reject{ |m| m['tz'].nil? }
    @timezones = (-11..14).map { |num| [
      sprintf("UTC%+d", num), 
      members_with_tz.count{ |m| (m['tz_offset'] / 3600) == num }
    ] }.to_h
  end
  
end
