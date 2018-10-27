#
# See https://api.slack.com/events/member_joined_channel
#
# Example payload:
# {"token"=>"xxxxx",
#  "team_id"=>"T05052K3Q",
#  "api_app_id"=>"A9MR2EQDQ",
#  "event"=> {
#    "type": "member_joined_channel",
#    "user": "W06GH7XHN",
#    "channel": "G0698JE0H",
#    "channel_type": "C",
#    "team": "T8MPF7EHL"},
#  "type"=>"event_callback",
#  "event_id"=>"EvAQE3M1PD",
#  "event_time"=>1526446776,
#  "authed_users"=>["U054D8V3L"]}
#
class SlackEvent::MemberJoinedChannelJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
    event = options[:event].with_indifferent_access

    # It would be highly odd for the channel not to exist,
    # since the only way this event is triggered is via channel-join
    # however, the website may not yet have the channel in it's database
    # and if it doesn't we won't be able to look it up so bail out now.
    channel = SlackChannel.find_by(uid: event[:channel])
    return if channel.nil?

    text = text_for(channel)
    return if text.blank?

    client = Slack::Web::Client.new
    client.chat_postEphemeral(
      channel: event[:channel],
      user: event[:user],
      text: text
    )

  # This too is highly unlikely, but if the use joins and leaves quickly
  # before this event can fire, it could happen.
  rescue Slack::Web::Api::Errors::SlackError => e
    raise unless %w[user_not_in_channel].include?(e.message)
  end

  private

  # Return the text message for the given channel. An empty response
  # is a valid response indicating there isn't a message for that channel.
  #
  # The text message should not be wrapped as that will break Slack's automatic
  # wrapping on presentation.
  #
  # Returns String (or nil)
  def text_for(channel)
    case channel.name
    when "work-offers"
      <<~END_OF_TEXT
        Welcome to our job posting channel. This channel is specifically for posting job offers or job-seeking information.

        For all other discussion of jobs, workplaces, career paths, etc. other than work opportunities, please use #work-career-chat.

        Your job offer should include the location, remote friendliness, company name, as well as instructions on how to apply.

        Be courteous and do not cross-post to other channels or post repeatedly for the same job offer. Do not pin your job post.

        Please use Slack threads to followup to keep the main channel's signal to noise ratio high.
      END_OF_TEXT
    end
  end

end
