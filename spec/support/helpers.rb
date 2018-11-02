module Helpers
  def authorize_admin!
    allow(@controller).to receive(:require_admin!).and_return(true)
  end

  def create_general_slack_channel
    SlackChannel.find_or_create_by!(
      is_general: true,
      name: 'general',
      uid: 'XXXXXXX'
    )
  end
end
