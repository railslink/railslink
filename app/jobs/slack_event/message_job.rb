#
# See https://api.slack.com/events-api#receiving_events
#
# Example payload:
#   {"token"=>"xxxxx",
#   "team_id"=>"T05052K3Q",
#   "api_app_id"=>"A9MR2EQDQ",
#   "event"=>{
#     "type"=>"message",
#     "user"=>"U6D5W3NCC",
#     "text"=>"something",
#     "ts"=>"1526446776.000167",
#     "channel"=>"C05052K88",
#     "event_ts"=>"1526446776.000167",
#     "channel_type"=>"channel"},
#   "type"=>"event_callback",
#   "event_id"=>"EvAQE3M1PD",
#   "event_time"=>1526446776,
#   "authed_users"=>["U054D8V3L"]}
#
class SlackEvent::MessageJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
    update_last_message_at
  end

  private

  def update_last_message_at
    SlackUser.where(uid: options[:event][:user]).
      update_all(last_message_at: Time.at(options[:event][:event_ts].to_i))
  end
end
