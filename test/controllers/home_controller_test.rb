class HomeControllerTest < ActionController::TestCase
  
  test 'should get index' do
    VCR.use_cassette('users.list') do
      VCR.use_cassette('channels.list') do
        # initialization
        payload = { token: ENV['SLACK_API_TOKEN'] }
        SlackApiResponse.fetch('users.list', payload)
        SlackApiResponse.fetch('channels.list', payload)
        
        # simulate access
        get :index
        assert_response :success
        assert assigns(:team_members_count) > 0
        assert assigns(:channels).first['name'].present?
        assert assigns(:timezones)['UTC-5'] > 0
        assert_select 'h1', configatron.app_name
      end
    end
  end
  
end
