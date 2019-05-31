#
# This comes through the slash commands API which has a
# slightly different payload than the events API
#
# Example payload:
#
# {
#   "token": "xxxx",
#   "team_id": "TCF0ZD3LL",
#   "team_domain": "railslink-dev",
#   "channel_id": "xxxx",
#   "channel_name": "xxxx",
#   "user_id": "xxxx",
#   "user_name": "xxxx",
#   "command": "/admins",
#   "text": "",
#   "response_url": "https://hooks.slack.com/commands/TCF0ZD3LL/640895425681/GDK2vHvOpxpvFrpRJnrvxiHS",
#   "trigger_id": "xxxx",
#   "slack": {
#     "event": {
#       "type": "admins"
#     }
#   },
#   "controller": "slack",
#   "action": "event"
# }
#

class SlackEvent::AdminsJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
    message = {
      text: admin_text,
      response_type: "ephemeral"
    }
    HTTParty.post(URI::parse(@options[:response_url]), body: message.to_json)
  end

  private

  # Return the text message for the list of admins.
  #
  # The text message should not be wrapped as that will break Slack's automatic
  # wrapping on presentation.
  #
  # Returns String (or nil)
  def admin_text
  <<~END_OF_TEXT
    *#{configatron.app_name} Admin Members*
    You can contact any of the following administrators on Slack or via email.

    #{admin_string}

    This information is also available at https://www.rubyonrails.link/admin_members
    END_OF_TEXT
  end

  def admin_string
    admins = SlackUser.admins.active.shuffle
    admins.map! do |admin|
      activity = "last active #{ApplicationController.helpers.time_ago_in_words(admin.last_message_at)} ago"
      " - <@#{admin.uid}> | #{admin.email} _(#{activity})_"
    end
    admins.join("\n")
  end

end
