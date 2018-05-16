namespace :slack do

  desc "Sync everything"
  task sync: ["sync:channels", "sync:users"] do
  end

  namespace :sync do
    desc "Sync channels"
    task channels: [:environment] do
      puts "Syncing slack channels..."
      begin
        client = Slack::Web::Client.new
        client.channels_list do |response|
          response.channels.each do |channel|
            puts " - #{channel["name"]}"
            channel = SlackChannel.find_or_create_from_api_response(channel)
            raise unless channel
          end
        end
      rescue Faraday::ConnectionFailed => e
        raise(e) unless e.message =~ /execution expired/
        puts " - #{e.class}: #{e.message}"
      end
    end

    desc "Sync users"
    task users: [:environment] do
      puts "Syncing slack users..."
      begin
        client = Slack::Web::Client.new
        client.users_list(include_locale: true) do |response|
          response.members.each do |member|
            puts " - #{member["name"]}"
            user = SlackUser.find_or_create_from_api_response(member)
            raise unless user
          end
        end
      rescue Faraday::ConnectionFailed => e
        raise(e) unless e.message =~ /execution expired/
        puts " - #{e.class}: #{e.message}"
      end
    end
  end
end
