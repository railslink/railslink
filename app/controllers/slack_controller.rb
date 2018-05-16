class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token!

  # see https://api.slack.com/events-api
  # see https://api.slack.com/events/url_verification
  def event
    if slack_params[:type] == "url_verification"
      render plain: slack_params[:challenge]
      return
    end
    head :ok
  end

  protected

  def verify_token!
    return if slack_params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
    head :forbidden
    return
  end

  def slack_params
    params.require(:slack).permit!
  end
end

__END__
"slack"=>{"token"=>"pL4lmrHYWTuJyCOEekfJfuw7",
"team_id"=>"T05052K3Q",
"api_app_id"=>"A9MR2EQDQ",
"event"=>{"type"=>"message",
"user"=>"U6D5W3NCC",
"text"=>"something",
"ts"=>"1526446776.000167",
"channel"=>"C05052K88",
"event_ts"=>"1526446776.000167",
"channel_type"=>"channel"},
"type"=>"event_callback",
"event_id"=>"EvAQE3M1PD",
"event_time"=>1526446776,
"authed_users"=>["U054D8V3L"]}
