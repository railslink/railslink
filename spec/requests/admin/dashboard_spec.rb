require "rails_helper"

RSpec.describe "Admin Dashboard page", type: :request do
  describe "without authorization" do
    it "redirects to the /auth/slack" do
      get "/admin"
      expect(response).to redirect_to("/auth/slack?require=admin")
    end
  end
end
