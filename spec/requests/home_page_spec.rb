require "rails_helper"

RSpec.describe "Home page", type: :request do
  it "returns http success" do
    get "/"
    expect(response).to have_http_status(200)
  end
end
