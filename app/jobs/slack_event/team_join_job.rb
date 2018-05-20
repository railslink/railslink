# 
# {token: "tokean123",
#  team_id: "team123",
#  api_app_id: "app123",
#  event: {
#    type: "team_join",
#    user: {
#      id: "user123",
#      team_id: "team123",
#      name: "name",
#      deleted: false,
#      color: "a63024",
#      real_name: " real name",
#      tz: "America/Chicago",
#      tz_label: "Central Daylight Time",
#      tz_offset: -18000,
#      profile: {
#        title: "",
#        phone: "",
#        skype: "",
#        real_name: "real name",
#        real_name_normalized: "real name",
#        display_name: "name",
#        display_name_normalized: "name",
#        fields: nil,
#        status_text: "",
#        status_emoji: "",
#        status_expiration: 0,
#        avatar_hash: "gfdce147bce1",
#        image_24:  "https://secure.gravatar.com/avatar/fdce14...",
#        image_32:  "https://secure.gravatar.com/avatar/fdce14...",
#        image_48:  "https://secure.gravatar.com/avatar/fdce14...",
#        image_72:  "https://secure.gravatar.com/avatar/fdce14...",
#        image_192:  "https://secure.gravatar.com/avatar/fdce1...",
#        image_512:  "https://secure.gravatar.com/avatar/fdce1...",
#        status_text_canonical: "",
#        team: "team123"
#      },
#      is_admin: false,
#      is_owner: false,
#      is_primary_owner: false,
#      is_restricted: false,
#      is_ultra_restricted: false,
#      is_bot: false,
#      updated: 1526773279,
#      is_app_user: false,
#      presence: "away"},
#      cache_ts: 1526773279,
#      event_ts: "1526773279.000067"
#  },
#  type: "event_callback",
#  event_id: "EvASL18CEQ",
#  event_time: 1526773279,
#  authed_users: ["auth123"]}
#
class SlackEvent::TeamJoinJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
    user = @options[:event][:user]
    return if user[:is_bot]

    welcome_user_to_team(user: user)
  end

  private

  def welcome_user_to_team(user:)
    client = Slack::Web::Client.new
    dm_channel = client.im_open(user: user[:id]).channel.id
    client.chat_postMessage(
      as_user: true,
      channel: dm_channel,
      text: welcome_text(user: user),
      mrkdwn: true,
      unfurl_links: false,
      unfurl_media: false
    )
  end

  def welcome_text(user:)
    %Q(
      *Welcome to #{configatron.app_name} #{user[:real_name] || user[:name]} :wave:*

      My name is RBot and I've got a few things to share with you.

      *We don't have many rules, but we do have a few:*

      1. Be nice to each other.
      2. Don't use `@everyone`, `@channel`, `@group` or `@here`.
      3. Don't ask if you can ask a question; just ask.
      4. Don't ask the same question in multiple channels.
      5. Wrap code in backticks. <https://slack.zendesk.com/hc/en-us/article_attachments/204977928/backticks.png|Example here>.
      6. See #1.

      Be sure to browse all the public channels to see any topics and conversations that might be interesting to you.

      If you're new to Ruby and/or Rails checkout <https://github.com/railslink/resources/wiki|our wiki> for resources to get started.

      We're glad to have you here!

      _– RBot and the Admins_
    ).strip.gsub(/^ +/, '')
  end
end
