require 'rails_helper'

RSpec.describe SlackEvent::TeamJoinJob, type: :job do
  let(:options) {{
    event: {
      user: {
        id: "user123",
        name: "johndoe",
        real_name: "John Doe",
        is_bot: false,
      },
    }
  }}

  describe "#perform" do
    it "does not welcome bots to the team" do
      options[:event][:user][:is_bot] = true
      expect(subject).not_to receive(:welcome_user_to_team)
      subject.perform(options)
    end

    it "welcomes the user to the team" do
      expect(subject).to receive(:welcome_user_to_team).with(user: options[:event][:user])
      subject.perform(options)
    end

    pending "should have better tests for the Slack::Web::Client"
  end
end
