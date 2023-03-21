# == Schema Information
#
# Table name: slack_channels
#
#  id            :bigint           not null, primary key
#  uid           :string
#  name          :string
#  is_archived   :boolean
#  is_general    :boolean          default(FALSE)
#  is_private    :boolean
#  purpose       :text
#  members_count :integer          default(0)
#  data          :json
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
