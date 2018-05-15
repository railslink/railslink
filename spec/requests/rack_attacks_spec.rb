require 'rails_helper'

RSpec.describe "RackAttacks", type: :request do
  describe "sanity checks" do
    it "allows the homepage" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "blocklist" do
    it "blocks /wp-login requests" do
      get "/foo/wp-login/bar"
      expect(response).to have_http_status(403)
    end

    it "blocks /wp-admin requests" do
      get "/foo/wp-admin/bar"
      expect(response).to have_http_status(403)
    end
  end
end
