require 'rails_helper'

RSpec.describe SlackController, type: :controller do
  describe "POST #event" do
    describe "when token is invalid" do
      it "returns http forbidden" do
        post :event, params: {token: "invalid"}
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "when token is valid" do
      let(:token) { "valid" }

      before do
        allow(ENV).to receive(:[]).with("SLACK_VERIFICATION_TOKEN").and_return(token)
      end

      it "returns http success" do
        post :event, params: {token: token}
        expect(response).to have_http_status(:success)
      end

      it "renders the provided challenge" do
        post :event, params: {token: token, challenge: "challenge"}
        expect(response.body).to eq "challenge"
      end
    end
  end
end
