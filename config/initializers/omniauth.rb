OmniAuth.config.failure_raise_out_environments = []

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, 
    ENV["SLACK_SIGNIN_API_KEY"], ENV["SLACK_SIGNIN_API_SECRET"],
    team: ENV["SLACK_TEAM"],
    scope: "channels:read, users:read",
    setup: true
  # if we ever add additional providers, we'll have to look out for csrf vulnerability in CVE-2015-9284
  # https://github.com/rubysec/ruby-advisory-db/pull/390#issuecomment-509105361
end
