require "rails_helper"

RSpec.describe "Users", type: :request do

  describe "index page" do
    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/users" }
    end

    it "returns http success" do
      authorize_admin!
      get "/admin/users"
      expect(response).to have_http_status(200)
    end
  end

  describe "show page" do
    before { create(:slack_user) }

    it_behaves_like "an authorized action" do
      let(:request) { get "/admin/users/#{SlackUser.first.id}" }
    end

    it "returns http success" do
      authorize_admin!
      get "/admin/users/#{SlackUser.first.id}"
      expect(response).to have_http_status(200)
    end
  end

end
