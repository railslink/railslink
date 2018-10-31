require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      authorize_admin!
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    before do
      create(:slack_user)
    end
    it "returns http success" do
      authorize_admin!
      get :show, { params: {id: SlackUser.first.id } }
      expect(response).to have_http_status(:success)
    end
  end

end
