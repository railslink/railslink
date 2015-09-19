class HomeController < ApplicationController
  
  def index
    @users_list = SlackApiResponse.latest('users.list')
    @valid_members = @users_list.response['members'].select{ |u| u['deleted'] == false }
    @team_members_count = @valid_members.size
    
    @channels = SlackApiResponse.latest('channels.list').response['channels']
      .sort_by{ |c| c['num_members'] }.reverse.first(6)
  end
  
end
