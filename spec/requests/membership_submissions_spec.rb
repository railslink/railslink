require "rails_helper"

RSpec.describe "Membership submissions", type: :request do
  describe "new membership submission page" do
    it "returns success for the new page" do
      get "/join-now"
      expect(response).to have_http_status(200)
    end
  end

  describe "membership creation" do
    describe "when honeypot :fax param is present" do
      it "redirects to the root page" do
        post "/join-now", params: { slack_membership_submission: { fax: "1" } }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "submission is invalid" do
      it "does not create the record" do
        post "/join-now", params: {
          slack_membership_submission: { email: "john@doe.com" }
        }

        expect(
          SlackMembershipSubmission.find_by(email: "john@doe.com")
        ).to be_nil
      end
    end

    describe "submission is valid" do
      it "creates the record" do
        post "/join-now", params: {
          slack_membership_submission: {
            email: "john@doe.com",
            first_name: "John",
            last_name: "Doe",
            introduction: "Once upon a time..."
          }
        }

        expect(
          SlackMembershipSubmission.find_by(email: "john@doe.com")
        ).to be_present
      end
    end
  end
end
