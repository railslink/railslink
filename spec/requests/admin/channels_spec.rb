require "rails_helper"

RSpec.describe "Channels", type: :request do
  describe "index page" do
    context "guest user" do
      it "redirects to /auth/slack" do
        get "/admin/channels"
        expect(response).to redirect_to("/auth/slack?require=admin")
      end
    end

    context "admin user" do
      it "returns http success" do
        authorize_admin!
        get "/admin/channels"
        expect(response).to have_http_status(200)
      end
    end
  end
end
