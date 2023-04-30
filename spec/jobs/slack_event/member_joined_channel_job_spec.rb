require 'rails_helper'

RSpec.describe SlackEvent::MemberJoinedChannelJob, type: :job do
  let(:channel_uid) { "channel123" }
  let(:user_uid)    { "user13" }

  let(:options) {{token: "token123",
     team_id:    "team123",
     api_app_id: "appid123",
     event: {
       type:         "member_joined_channel",
       user:         user_uid,
       channel:      channel_uid,
       channel_type: "C",
       team:         "team123",
       event_ts:     "1526773280.000029"},
       type:         "event_callback",
       event_id:     "EvATPK4546",
       event_time:   1526773280,
       authed_users: ["auth123"]}
  }

  describe "#perform" do
    context "when SlackChannel does not exist" do
      it "does nothing" do
        expect(Slack::Web::Client).not_to receive(:new)
        subject.perform(options)
      end
    end

    context "when SlackChannel exists" do
      let!(:channel) { create(:slack_channel, uid: channel_uid) }

      context "when there is no text for channel" do
        before do
          channel.update!(name: "no-text-for-me")
        end

        it "does nothing" do
          expect(subject).to receive(:text_for).and_call_original
          expect(Slack::Web::Client).not_to receive(:new)
          subject.perform(options)
        end

        it "squelches user_not_in_channel errors" do

        end
      end

      context "when there is text for channel" do
        before do
          allow(subject).to receive(:text_for).and_return("string")
        end

        it "squelches user_not_in_channel errors" do
          allow(Slack::Web::Client).to receive(:new).
            and_raise(Slack::Web::Api::Errors::SlackError.new("user_not_in_channel"))

          expect { subject.perform(options) }.not_to raise_error
        end

        it "raises other errors" do
          allow(Slack::Web::Client).to receive(:new).
            and_raise(Slack::Web::Api::Errors::SlackError.new("some_other_error"))

          expect {
            subject.perform(options)
          }.to raise_error(Slack::Web::Api::Errors::SlackError)
        end
      end

      context "when channel is #job-offers" do
        before do
          channel.update!(name: "job-offers")
        end

        it "posts ephmerally to user" do
          client = double("Slack::Web::Client")
          expect(Slack::Web::Client).to receive(:new).and_return(client)
          expect(client).to receive(:chat_postEphemeral).with(
            channel: channel_uid,
            user: user_uid,
            text: kind_of(String)
          )
          subject.perform(options)
        end
      end
    end
  end
end
