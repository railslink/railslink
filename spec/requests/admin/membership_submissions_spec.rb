require "rails_helper"

RSpec.describe "Membership submissions", type: :request do
  describe "index page" do
    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/membership_submissions" }
    end

    it "redirects to admin dashboard" do
      authorize_admin!
      get "/admin/membership_submissions"
      expect(response).to redirect_to(admin_path)
    end
  end

  describe "Pending submissions" do

    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/membership_submissions/pending" }
    end

    context "when pending submissions are zero" do
      it "redirects to admin path" do
        authorize_admin!
        get "/admin/membership_submissions/pending"
        expect(response).to redirect_to(admin_path)
      end
    end

    context "when pending submissions are greater than zero" do
      let!(:slack_membership) { create(:slack_membership_submission) }

      it "returns success" do
        authorize_admin!
        get "/admin/membership_submissions/pending"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "Submissions approval" do
    let!(:slack_membership) { create(:approved_slack_membership_submission) }

    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/membership_submissions/x/approve" }
    end

    it "redirects to admin path" do
      authorize_admin!
      get "/admin/membership_submissions/#{slack_membership.id}/approve"
      expect(response).to redirect_to(pending_admin_membership_submissions_path)
    end
  end

  describe "Submissions rejection" do
    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/membership_submissions/x/reject" }
    end

    context "when submission is pending" do
      let!(:slack_membership) { create(:slack_membership_submission) }

      before do
        authorize_admin!
        get "/admin/membership_submissions/#{slack_membership.id}/reject"
      end

      it "rejects slack membership submission" do
        expect(slack_membership.reload.status).to eq "rejected"
      end

      it "redirects to pending admin membership submissions path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end

    context "when submission is not pending" do
      let!(:slack_membership) { create(:approved_slack_membership_submission) }

      before do
        authorize_admin!
        get "/admin/membership_submissions/#{slack_membership.id}/reject"
      end

      it "rejects slack membership submission" do
        expect(slack_membership.reload.status).to eq "approved"
      end

      it "redirects to admin pending membership path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end
  end
end
