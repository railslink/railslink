class Admin::ChannelsController < ApplicationController
  def index
    @channels = SlackChannel.order(:is_archived, :name)
  end
end
