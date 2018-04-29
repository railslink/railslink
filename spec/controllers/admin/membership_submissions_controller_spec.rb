require 'rails_helper'

RSpec.describe Admin::MembershipSubmissionsController, type: :controller do

  describe "GET #pending" do
    it "returns http success" do
      get :pending
      expect(response).to have_http_status(:success)
    end
  end

end
