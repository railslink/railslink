require 'rails_helper'

RSpec.describe SlackEvent::AdminsJob, type: :job do
  let(:options) {{
    token: "fake token",
    response_url: "https://www.fakeurl.com",
    event: {
      type: "admins"
    }
  }}
  
  describe "#perform" do
    it "responds with a list of admins" do
      expect(subject).to receive(:admin_text).and_return("list of admins")
      subject.perform(options)
    end
  end
end
