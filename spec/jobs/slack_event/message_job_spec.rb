require 'rails_helper'

RSpec.describe SlackEvent::MessageJob, type: :job do
  describe "#update_last_message_at" do
    it "updates the user's last_message_at attribute" do
      user = create(:slack_user)
      event_ts = Time.current
      subject.perform( event: { user: user.uid, event_ts: event_ts.to_f.to_s })
      expect(user.reload.last_message_at.to_i).to eq event_ts.to_i
    end
  end
end
