require 'rails_helper'

RSpec.describe IpInfo, type: :model do
  context "exceptions" do
    let(:subject) { described_class.new("73.11.237.17") }

    it "is unsuccessful when the network times out" do
      allow(Net::HTTP).to receive(:get).and_raise(Net::OpenTimeout)
      expect(subject.successful?).to eq false
    end

    it "is unsuccessful when the json is invalid" do
      allow(Net::HTTP).to receive(:get).and_return("") # invalid JSON
      expect(subject.successful?).to eq false
    end

    it "is unsuccessful when the timeout is reached" do
      allow(Net::HTTP).to receive(:get).and_raise(Timeout::Error)
      expect(subject.successful?).to eq false
    end
  end

  context "invalid ip addresses" do
    let(:subject) { described_class.new("invalid") }

    it "is unsuccessful" do
      expect(subject.successful?).to eq false
    end

    it "sets a message about why" do
      expect(subject.message).to match(/invalid/)
    end
  end

  context "private ip addresses" do
    let(:subject) { described_class.new("127.0.0.1") }

    it "is unsuccessful" do
      expect(subject.successful?).to eq false
    end

    it "sets a message about why" do
      expect(subject.message).to match(/reserved/)
    end
  end

  context "valid ip addresses" do
    let(:subject) { described_class.new("73.11.237.17") }

    it "is successful" do
      expect(subject.successful?).to eq true
    end

    it "sets a variety of key/values" do
      aggregate_failures do
        expect(subject.city).to eq "Olympia"
        expect(subject.region).to eq "WA"
        expect(subject.country).to eq "United States"
      end
    end

    it "knows how to convert key names" do
      aggregate_failures do
        expect(subject.country_code).to eq "US"
        expect(subject.region_name).to eq "Washington"
      end
    end
  end
end
