namespace :slack do
  
  desc 'Updates Slack team info'
  task update: :environment do |task_name, args|
    
    payload = { token: ENV['SLACK_API_TOKEN'] }
    
    # Call Slack API and save the response even if it was failure.
    %w(users.list channels.list).each do |method_name|
      json = RestClient.post "https://slack.com/api/#{method_name}", payload, content_type: :json
      hash = JSON.parse(json)
      SlackApiResponse.create(
        method_name: method_name,
        ok: hash['ok'],
        response: hash,
      )
    end
    
  end
end
