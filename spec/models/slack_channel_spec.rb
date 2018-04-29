require 'rails_helper'
require 'models/concerns/uidable'

RSpec.describe SlackChannel, type: :model do
  it_behaves_like "a uidable concern"
end
