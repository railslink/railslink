class HomeController < ApplicationController

  def index
    @users_list = SlackApiResponse.latest('users.list')
    @valid_members = @users_list.response['members'].select{
      |u| u['deleted'] == false
    }
    @team_members_count = @valid_members.size

    @channels_list = SlackApiResponse.latest('channels.list')
    @channels_hash = @channels_list.response['channels'].map{
      |c| [c['name'], c]
    }.to_h
  end

end
