require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do

  describe "without authorization" do
    describe "GET #index" do
      it "redirects to the /auth/slack" do
        get :index
        expect(response).to redirect_to("/auth/slack?require=admin")
      end
    end
  end

end
