require 'rails_helper'

RSpec.describe SlackEvent::MessageJob, type: :job do
  describe "#request_to_invite" do
    context "when not an invitation request" do
      it "won't invoke when message text is wrong" do
        expect(subject).to receive(:request_to_invite).and_return(false)
        payload = { event: { text: "not an invitation request" } }
        subject.perform(payload)
      end

      it "won't invoke when fallback text is wrong" do
        expect(subject).to receive(:request_to_invite).and_return(false)
        payload = { event: {
          text: "<@UQ5TPSAKG> requested to invite one person to this workspace.",
          attachments: [{fallback: "not an approve or deny fallback"}]
        } }
        subject.perform(payload)
      end
    end

    context "when an invitation request" do
      let(:user_id) { "UQ5TPSAKG" }
      let(:payload) {{
        event: {
          text: "<@#{user_id}> requested to invite one person to this workspace.",
          attachments: [{fallback: "Approve/Deny the invite request on team site"}]
        }
      }}

      it "sends a dm to the user" do
        client = double(Slack::Web::Client)
        im = double(channel: double(id: 123))
        expect(Slack::Web::Client).to receive(:new).and_return(client)
        expect(client).to receive(:im_open).with(user: user_id).and_return(im)
        expect(client).to receive(:chat_postMessage).with(hash_including(
          channel: 123,
          text: kind_of(String)
        ))
        subject.perform(payload)
      end
    end
  end

  describe "#update_last_message_at" do
    it "updates the user's last_message_at attribute" do
      user = create(:slack_user)
      event_ts = Time.current
      subject.perform( event: { user: user.uid, event_ts: event_ts.to_f.to_s })
      expect(user.reload.last_message_at.to_i).to eq event_ts.to_i
    end

    it "won't invoke if a previous handler processes the message" do
      allow(subject).to receive(:request_to_invite).and_return(true)
      subject.perform({})
      expect(subject).not_to receive(:update_last_message_at)
    end
  end
end
