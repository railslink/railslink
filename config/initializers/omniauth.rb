OmniAuth.config.failure_raise_out_environments = []

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, 
    ENV["SLACK_SIGNIN_API_KEY"], ENV["SLACK_SIGNIN_API_SECRET"],
    team: ENV["SLACK_TEAM"],
    scope: "channels:read, users:read",
    setup: true
end
