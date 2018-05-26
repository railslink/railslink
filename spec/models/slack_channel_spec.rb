require 'rails_helper'
require 'models/concerns/uidable'

RSpec.describe SlackChannel, type: :model do
  it_behaves_like "a uidable concern"

  describe "#name_with_hash" do
    it "prepends a hash to the channel name" do
      subject.name = "foo"
      expect(subject.name_with_hash).to eq "#foo"
    end
  end
end
