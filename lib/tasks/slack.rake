namespace :slack do
  
  desc 'Updates Slack team info'
  task update: :environment do |task_name, args|
    
    payload = { token: ENV['SLACK_API_TOKEN'] }
    
    # Call Slack API and save the response even if it was failure.
    %w(users.list channels.list).each do |method_name|
      SlackApiResponse.fetch(method_name, payload)
    end
    
  end
end
