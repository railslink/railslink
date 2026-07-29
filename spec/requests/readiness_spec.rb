require "rails_helper"

RSpec.describe "Readiness", type: :request do
  it "returns success when the database is reachable" do
    get "/readyz"

    expect(response).to have_http_status(:ok)
  end

  it "returns service unavailable when the database is not reachable" do
    allow(ActiveRecord::Base).to receive(:connection).and_raise(
      ActiveRecord::ConnectionNotEstablished
    )

    get "/readyz"

    expect(response).to have_http_status(:service_unavailable)
  end
end
