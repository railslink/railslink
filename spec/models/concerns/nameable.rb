RSpec.shared_examples "a nameable concern" do
  describe "#name" do
    it "joins first and last names together" do
      subject.first_name = "John"
      subject.last_name = "Doe"
      expect(subject.name).to eq "John Doe"
    end

    it "strips spaces" do
      subject.first_name = " John "
      subject.last_name = " Doe "
      expect(subject.name).to eq "John Doe"
    end

    it "uses first name when last name is blank" do
      subject.first_name = "John"
      subject.last_name = ""
      expect(subject.name).to eq "John"
    end

    it "uses last name when first name is blank" do
      subject.first_name = ""
      subject.last_name = "Doe"
      expect(subject.name).to eq "Doe"
    end
  end
end
