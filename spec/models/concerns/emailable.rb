RSpec.shared_examples "a emailable concern" do
  it { should validate_uniqueness_of(:email) }

  describe "#sanitize_email" do
    it "lower cases the email" do
      subject.update!(email: "JOHN@DOE.COM")
      expect(subject.email).to eq "john@doe.com"
    end

    it "strips spaces" do
      subject.update!(email: " john@doe.com ")
      expect(subject.email).to eq "john@doe.com"
    end

    it "converts a blank string to nil" do
      subject.update!(email: "")
      expect(subject.email).to eq nil
    end
  end
end
