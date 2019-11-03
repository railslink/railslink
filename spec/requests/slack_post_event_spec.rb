require "rails_helper"

RSpec.describe "Slack post event", type: :request do
  describe "publishing events to Redis" do
    it "publishes events even if token is invalid" do
      expect(REDIS).to receive(:publish).with(
        :slack_events, { token: "invalid" }.to_json
      )

      post "/slack/event", params: { slack: { token: "invalid" } }
    end

    it "sends errors to Rollbar" do
      error = StandardError.new("oops")
      allow(REDIS).to receive(:publish).and_raise(error)
      expect(Rollbar).to receive(:error).with(
        error, slack_params: { "foo" => "bar" }
      )
      post "/slack/event", params: { slack: { foo: "bar" } }
    end
  end

  describe "when token is invalid" do
    it "returns http forbidden" do
      post "/slack/event", params: { slack: { token: "invalid" } }
      expect(response).to have_http_status(403)
    end
  end

  describe "when token is valid" do
    let(:token) { "valid" }

    before do
      stub_env('SLACK_VERIFICATION_TOKEN', token)
    end

    it "returns http success" do
      post "/slack/event", params: { slack: { token: token } }
      expect(response).to have_http_status(:success)
    end

    describe "type url_verification" do
      it "renders the provided challenge" do
        post "/slack/event", params: {
          slack: { token: token, type: "url_verification", challenge: "challenge" }
        }
        expect(response.body).to eq "challenge"
      end
    end

    describe "event type admins" do
      it "enqueues SlackEvent::AdminsJob" do
        slack_params = {
          token: token,
          response_url: "https://www.fakeurl.com",
          event: {
            type: "admins"
          }
        }.with_indifferent_access
        expect(SlackEvent::AdminsJob).to receive(:perform_later).with(slack_params)
        post "/slack/event", params: { slack: slack_params }
      end
    end

    describe "event type message" do
      it "enqueues SlackEvent::MessageJob" do
        slack_params = {
          token: token,
          event: {
            type: "message",
            user: "u123"
          }
        }.with_indifferent_access
        expect(SlackEvent::MessageJob).to receive(:perform_later).with(slack_params)
        post "/slack/event", params: { slack: slack_params }
      end
    end

    describe "event type member_joined_channel" do
      it "enqueues SlackEvent::MemberJoinedChannelJob" do
        slack_params = {
          token: token,
          event: {
            type: "member_joined_channel"
          }
        }.with_indifferent_access
        expect(SlackEvent::MemberJoinedChannelJob).to receive(:perform_later).with(slack_params)
        post "/slack/event", params: { slack: slack_params }
      end
    end

    describe "event type team_join" do
      it "enqueues SlackEvent::TeamJoinJob" do
        slack_params = {
          token: token,
          event: {
            type: "team_join"
          }
        }.with_indifferent_access
        expect(SlackEvent::TeamJoinJob).to receive(:perform_later).with(slack_params)
        post "/slack/event", params: { slack: slack_params }
      end
    end

    describe "event type unhandled" do
      it "enqueues SlackEvent::UnhandledJob" do
        slack_params = {
          token: token,
          event: {
            type: "unhandled"
          }
        }.with_indifferent_access
        expect(SlackEvent::UnhandledJob).to receive(:perform_later).with(slack_params)
        post "/slack/event", params: { slack: slack_params }
      end
    end

    context "host is not railslink-dev.herokuapp.com" do
      it "does not enqueue SlackEvent::UnhandledJob in addition to the normal job" do
        slack_params = {
          token: token,
          event: {
            type: "message",
            user: "u123"
          }
        }.with_indifferent_access
        expect(SlackEvent::UnhandledJob).not_to receive(:perform_later)
        expect(SlackEvent::MessageJob).to receive(:perform_later).with(slack_params)
        post "/slack/event",
          params: { slack: slack_params },
          headers: { "Host" => "not-railslink-dev.herokuapp.com" }
      end
    end

    context "host is railslink-dev.herokuapp.com" do
      it "enqueues SlackEvent::UnhandledJob in addition to the normal job" do
        slack_params = {
          token: token,
          event: {
            type: "message",
            user: "u123"
          }
        }.with_indifferent_access
        expect(SlackEvent::UnhandledJob).to receive(:perform_later).with(slack_params)
        expect(SlackEvent::MessageJob).to receive(:perform_later).with(slack_params)
        post "/slack/event",
          params: { slack: slack_params },
          headers: { "Host" => "railslink-dev.herokuapp.com" }
      end
    end
  end
end
