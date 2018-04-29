namespace :slack do
  namespace :test do

    desc "Test Slack API"
    task api: [:environment] do
      puts "Testing slack api..."
      client = Slack::Web::Client.new
      response = client.auth_test
      puts response.to_json
    end
  end
end
