require 'test_helper'

class SlackApiResponseTest < ActiveSupport::TestCase
  
  payload = { token: ENV['SLACK_API_TOKEN'] }
  
  test 'users.list' do
    
    method_name = 'users.list'
    
    VCR.use_cassette(method_name) do
      response = SlackApiResponse.fetch(method_name, payload)
      assert response.persisted?
      
      users_list = SlackApiResponse.latest(method_name)
      assert users_list.response['members'].size > 0
    end
    
  end
  
  test 'channels.list' do
    
    method_name = 'channels.list'
    
    VCR.use_cassette(method_name) do
      response = SlackApiResponse.fetch(method_name, payload)
      assert response.persisted?
      
      channels_list = SlackApiResponse.latest(method_name)
      assert channels_list.response['channels'].size > 0
      puts channels_list.response['channels'].first
    end
    
  end

end
