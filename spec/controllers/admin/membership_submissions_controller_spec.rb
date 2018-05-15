require 'rails_helper'

RSpec.describe Admin::MembershipSubmissionsController, type: :controller do
  describe "GET #index" do
    it "redirects to admin dashboard" do
      allow(@controller).to receive(:require_admin!).and_return(true)
      get :index
      expect(response).to redirect_to(admin_path)
    end
  end

  pending "GET #pending"
  pending "POST #pending"
  pending "POST #reject"
end
