RSpec.shared_examples "a uidable concern" do
  it { should validate_presence_of(:uid) }
end
