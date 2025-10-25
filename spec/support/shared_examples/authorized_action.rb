RSpec.shared_examples "an authorized action" do
  it "redirects to /auth/slack" do
    request
    expect(response).to redirect_to("/auth/slack?require=admin")
  end
end
