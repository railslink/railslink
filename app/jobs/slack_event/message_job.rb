#
# See https://api.slack.com/events-api#receiving_events
#
class SlackEvent::MessageJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access

    %i[
    request_to_invite
    update_last_message_at
    ].each do |method|
      return if send(method)
    end
  end

  private

  # Example payload:
  # {"token"=>"1mgp0bBfXC5V7XaGnV7e0RIY",
  #  "team_id"=>"TCF0ZD3LL",
  #  "api_app_id"=>"ACELG3B4H",
  #  "event"=>
  #   {"bot_id"=>"B01",
  #    "type"=>"message",
  #    "text"=>"<@UQ5TPSAKG> requested to invite one person to this workspace.",
  #    "user"=>"USLACKBOT",
  #    "ts"=>"1572807140.000900",
  #    "team"=>"TCF0ZD3LL",
  #    "attachments"=>
  #     [{"text"=> "*Name*: Philip Two\n*Email*: <mailto:philip+2@pjkh.com|philip+2@pjkh.com>", "id"=>1},
  #      {"text"=>"*Channel:* <#CPQSZEM34|admin-invitations>", "id"=>2},
  #      {"text"=>"*Reason for Request*:\nthe reason i'm inviting", "id"=>3},
  #      {"callback_id"=>"inviterequests_TCF0ZD3LL",
  #       "fallback"=>"Approve/Deny the invite request on team site",
  #       "id"=>4,
  #       "actions"=>
  #        [{"id"=>"1", "name"=>"approve", "text"=>"Send Invitation", "type"=>"button", "value"=>"819741771957", "style"=>"primary"},
  #         {"id"=>"2", "name"=>"deny", "text"=>"Deny", "type"=>"button", "value"=>"819741771957", "style"=>"danger"}]}],
  #    "channel"=>"CPQSZEM34",
  #    "event_ts"=>"1572807140.000900",
  #    "channel_type"=>"channel"},
  #  "type"=>"event_callback",
  #  "event_id"=>"EvQ5HCAE6T",
  #  "event_time"=>1572807140,
  #  "authed_users"=>["UCFC0B6E9"]}
  def request_to_invite
    return false unless options.dig(:event, :text).to_s.match?(/ requested to invite .* to this workspace./)
    return false unless options.dig(:event, :attachments).any? { |e| e[:fallback] =~ /invite request on team site/ }

    user_id = options.dig(:event, :text).match(/^<@(.*?)>/).captures.first

    message = %Q(
      Hi - You recently invited someone to join this Slack team via the slash
      command `/invite_people`. To help reduce the number of bots and spam
      accounts we ask that everyone join by filling out the form below:

      https://www.rubyonrails.link/join-now

      Will you ask your friend to fill out that form? Once done our goal is to
      review and approve it in 24 hours.

      Thanks!

      _– RBot and the Admins_
    ).strip.gsub(/^ +/, '')

    client = Slack::Web::Client.new
    dm_channel = client.im_open(user: user_id).channel.id
    client.chat_postMessage(
      as_user: true,
      channel: dm_channel,
      text: message,
      mrkdwn: true,
      unfurl_links: false,
      unfurl_media: false
    )

    true
  end

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
  def update_last_message_at
    SlackUser.where(uid: options[:event][:user]).
      update_all(last_message_at: Time.at(options[:event][:event_ts].to_i))

    true
  end
end
