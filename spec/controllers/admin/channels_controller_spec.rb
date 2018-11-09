require 'rails_helper'

RSpec.describe Admin::ChannelsController, type: :controller do

  describe "GET #index" do
    context "guest user" do
      it "redirects to /auth/slack" do
        get :index
        expect(response).to redirect_to("/auth/slack?require=admin")
      end
    end

    context "admin user" do
      it "returns http success" do
        authorize_admin!
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

end
