# frozen_string_literal: true

class SlackChannelPresenter < BasePresenter
  def cleaned_purpose
    return "" if purpose.blank?

    channel_ids = purpose.match(/<#(C\w+)\|>/)&.captures
    return purpose if channel_ids.nil?

    channel_ids.each do |channel_id|
      channel = SlackChannel.find_by(uid: channel_id)
      next unless channel

      purpose.gsub!("<##{channel_id}|>", "##{channel.name}")
    end

    purpose
  end
end
