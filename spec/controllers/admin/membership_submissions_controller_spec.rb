require 'rails_helper'

RSpec.describe Admin::MembershipSubmissionsController, type: :controller do
  describe "GET #index" do
    it "redirects to admin dashboard" do
      authorize_admin!
      get :index
      expect(response).to redirect_to(admin_path)
    end
  end

  describe "GET #pending" do
    describe "when pending submissions are zero" do
      before do
        authorize_admin!
        get :pending
      end

      it "sets the flash to indicate there are no submissions" do
        expect(flash[:info]).to match(/no pending submissions/i)
      end

      it "redirects to admin path" do
        expect(response).to redirect_to(admin_path)
      end
    end

    describe "when pending submissions are greater than zero" do
      let!(:slack_membership) { create(:slack_membership_submission) }

      before do
        authorize_admin!
        get :pending
      end

      it "does not set flash/info" do
        expect(flash[:info]).to be_blank
      end

      it "returns success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #approve" do
    describe "when pending submissions are zero" do
      let!(:slack_membership) { create(:approved_slack_membership_submission) }

      before do
        authorize_admin!
        get :approve, {params: {id: slack_membership.id}}
      end

      it "sets flash/warning to indicate previous status" do
        expect(flash[:warning]).to match(/was previously approved/i)
      end

      it "redirects to admin path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end
  end

  describe "GET #reject" do
    describe "when submission is pending" do
      let!(:slack_membership) { create(:slack_membership_submission) }

      before do
        authorize_admin!
        post :reject, {params: {id: slack_membership.id}}
      end

      it "rejects slack membership submission" do
        expect(slack_membership.reload.status).to eq "rejected"
      end

      it "sets the flash/info to indicate membership rejection" do
        expect(flash[:info]).to match(/was rejected/i)
      end

      it "redirects to pending admin membership submissions path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end

    describe "when submission is not pending" do
      let!(:slack_membership) { create(:approved_slack_membership_submission) }

      before do
        authorize_admin!
        post :reject, {params: {id: slack_membership.id}}
      end

      it "rejects slack membership submission" do
        expect(slack_membership.reload.status).to eq "approved"
      end

      it "sets the flash/warning to indicate membership rejection" do
        expect(flash[:warning]).to match(/was previously approved/i)
      end

      it "redirects to admin pending membership path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end
  end

end
