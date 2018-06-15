require 'rails_helper'

RSpec.describe Admin::MembershipSubmissionsController, type: :controller do
  describe "GET #index" do
    it "redirects to admin dashboard" do
      allow(@controller).to receive(:require_admin!).and_return(true)
      get :index
      expect(response).to redirect_to(admin_path)
    end
  end

  describe "GET #pending" do
    describe "when pending submissions are zero" do
      before do
        allow(@controller).to receive(:require_admin!).and_return(true)
        get :pending
      end

      it "redirects to admin_path" do
        expect(response).to redirect_to(admin_path)
      end

      it "sets flash/info" do
        expect(flash[:info]).to match(/submissions/i)
      end
    end

    describe "when pending submissions are grater than zero" do
      before do
        @slack_membership_1 = create(:slack_membership_submission, email: 'johndoe@email.com')
        @slack_membership_2 = create(:slack_membership_submission, email: 'johndoe2@email.com')
        allow(@controller).to receive(:require_admin!).and_return(true)
        get :pending
      end

      it "does not set flash/info and returns success" do
        expect(flash[:info]).to be_blank
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #approve" do
    describe "when pending submissions are zero" do
      before do
        @slack_membership = create(:slack_membership_submission, email: 'johndoe@email.com', status: 1)
        allow(@controller).to receive(:require_admin!).and_return(true)
        get :approve, {params: {id: @slack_membership.id}}
      end

      it "does set flash/info" do
        expect(flash[:warning]).to match(/approved/i)
      end

      it "redirects to admin_path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end
  end

  describe "POST #reject" do
    describe "when submission is pending" do
      before do
        @slack_membership = create(:slack_membership_submission, email: 'johndoe@email.com')
        allow(@controller).to receive(:require_admin!).and_return(true)
        post :reject, {params: {id: @slack_membership.id}}
      end

      it "rejects submission and sets flash/info" do
        expect(@slack_membership.reload.status).to eq "rejected"
        expect(flash[:info]).to match(/rejected/i)
      end

      it "redirects to pending_admin_membership_submissions_path" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end

    describe "when submission is not pending" do
      before do
        @slack_membership = create(:slack_membership_submission, email: 'johndoe@email.com', status: 1)
        allow(@controller).to receive(:require_admin!).and_return(true)
        post :reject, {params: {id: @slack_membership.id}}
      end

      it "rejects submission and sets flash/warning" do
        expect(@slack_membership.reload.status).to eq "approved"
        expect(flash[:warning]).to match(/previously/i)
      end

      it "redirects to admin pending membership" do
        expect(response).to redirect_to(pending_admin_membership_submissions_path)
      end
    end
  end

end
