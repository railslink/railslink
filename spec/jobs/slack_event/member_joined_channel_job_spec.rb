require 'rails_helper'

RSpec.describe SlackEvent::MemberJoinedChannelJob, type: :job do
  let(:options) {{token: "token123",
     team_id:    "team123",
     api_app_id: "appid123",
     event: {
       type:         "member_joined_channel",
       user:         "user13",
       channel:      "channel123",
       channel_type: "C",
       team:         "team123",
       event_ts:     "1526773280.000029"},
       type:         "event_callback",
       event_id:     "EvATPK4546",
       event_time:   1526773280,
       authed_users: ["auth123"]}
  }

  describe "#perform" do
    it "does nothing yet" do
      subject.perform(options)
    end
  end
end
