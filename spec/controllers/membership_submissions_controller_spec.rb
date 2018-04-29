require 'rails_helper'

RSpec.describe MembershipSubmissionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    describe "when honeypot :fax param is present" do
      before do
        post :create, params: {slack_membership_submission: {fax: "1"}}
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "does not set flash/info" do
        expect(flash[:info]).to be_blank
      end
    end

    describe "when submission is invalid" do
      before do
        post :create, params: {slack_membership_submission: {email: "john@doe.com"}}
      end

      it "sets flash/danger" do
        expect(flash[:danger]).to match(/please try again/i)
      end

      it "does not create the record" do
        expect(SlackMembershipSubmission.find_by(email: "john@doe.com")).to eq nil
      end
    end

    describe "when submission is valid" do
      before do
        post :create, params: {slack_membership_submission: {
          email: "john@doe.com",
          first_name: "John",
          last_name: "Doe",
        }}
      end

      it "sets flash/info" do
        expect(flash[:info]).to match(/thanks/i)
      end

      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end

      it "creates the record" do
        expect(SlackMembershipSubmission.find_by(email: "john@doe.com")).to be_present
      end
    end
  end
end
