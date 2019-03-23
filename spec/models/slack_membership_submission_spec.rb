require 'rails_helper'
require 'models/concerns/emailable'
require 'models/concerns/nameable'

RSpec.describe SlackMembershipSubmission, type: :model do
  let(:subject) { build(:slack_membership_submission) }

  it "is valid from the factory" do
    expect(subject).to be_valid
  end

  it_behaves_like "a emailable concern"
  it_behaves_like "a nameable concern"

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should allow_value("").for(:website_url) }
    it { should allow_value("http://web.site").for(:website_url) }
    it { should allow_value("https://web.site").for(:website_url) }
    it { should_not allow_value("https://web").for(:website_url) }
    it { should_not allow_value("sftp://ftp.site").for(:website_url) }

    it { should allow_value("").for(:github_url) }
    it { should allow_value("http://github.com/johndoe").for(:github_url) }
    it { should allow_value("https://github.com/johndoe").for(:github_url) }
    it { should_not allow_value("https://notgithub.com/johndoe").for(:github_url) }

    it { should allow_value("").for(:linkedin_url) }
    it { should allow_value("http://linkedin.com/in/johndoe").for(:linkedin_url) }
    it { should allow_value("https://linkedin.com/in/johndoe").for(:linkedin_url) }
    it { should allow_value("https://www.linkedin.com/in/johndoe").for(:linkedin_url) }
    it { should_not allow_value("https://notlinkedin.com/johndoe").for(:linkedin_url) }

    it { should validate_presence_of(:introduction) }
  end

  it "sets status to pending on create" do
    subject.save!
    expect(subject.status).to eq "pending"
  end

  describe "#approve_and_invite!" do
    pending
  end

  describe "#ip_address_location" do
    it "returns nil if ip_address is nil" do
      subject.ip_address = nil
      expect(subject.ip_address_location).to eq nil
    end

    it "returns nil if ip_address is private" do
      subject.ip_address = "127.0.0.1"
      expect(subject.ip_address_location).to eq nil
    end

    it "returns location string if ip_address is valid" do
      subject.ip_address = "73.11.237.17"
      expect(subject.ip_address_location).to eq "Olympia, WA, United States"
    end

  end
end
