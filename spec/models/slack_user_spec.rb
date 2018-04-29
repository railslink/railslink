require 'rails_helper'
require 'models/concerns/uidable'
require 'models/concerns/emailable'
require 'models/concerns/nameable'

RSpec.describe SlackUser, type: :model do
  let(:subject) { build(:slack_user) }

  it "is valid from the factory" do
    expect(subject).to be_valid
  end

  it_behaves_like "a uidable concern"
  it_behaves_like "a emailable concern"
  it_behaves_like "a nameable concern"

  describe ".find_or_create_from_auth_hash" do
    let(:auth_hash) { Hashie::Mash.new(
      extra: { user_info: { user: { uid: "u123", username: "johndoe" }}},
      credentials: { token: "xoxp-123" }
    )}

    it "finds or creates a user from the api response" do
      expect(described_class).to receive(:find_or_create_from_api_response)
        .with({ uid: "u123", username: "johndoe" }).and_return(subject)
      described_class.find_or_create_from_auth_hash(auth_hash)
    end

    it "sets the user's xoxp_token" do
      allow(described_class).to receive(:find_or_create_from_api_response).and_return(subject)
      user = described_class.find_or_create_from_auth_hash(auth_hash)
      expect(user.xoxp_token).to eq "xoxp-123"
    end
  end

  describe ".find_or_create_from_api_response" do
    pending
  end

  describe ".tz_offset_distribution" do
    it "returns a sorted hash of offsets and counts" do
      create(:slack_user, tz_offset: nil)
      create(:slack_user, tz_offset: 3600)
      create(:slack_user, tz_offset: 3600)
      create(:slack_user, tz_offset: -7200)

      expect(described_class.tz_offset_distribution).to eq(
        {"UTC-2" => 1, "UTC+1" => 2}
      )
    end
  end
end
