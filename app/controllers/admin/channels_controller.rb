class Admin::ChannelsController < AdminController
  def index
    @channels = SlackChannel.order(:is_archived, :name)
  end
end
