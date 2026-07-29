# frozen_string_literal: true

class SlackChannelPresenter < BasePresenter
  # Slack writes channel references into a purpose as "<#C123|>". Resolve them all
  # in one query instead of one per reference, and build a new string rather than
  # gsub!-ing the model's own attribute in place — the old version mutated the
  # loaded record, which showed up as spurious dirty tracking. `match` also only
  # ever found the first reference; `scan` finds them all.
  CHANNEL_REFERENCE = /<#(C\w+)\|>/

  def cleaned_purpose
    return "" if purpose.blank?

    uids = purpose.scan(CHANNEL_REFERENCE).flatten.uniq
    return purpose if uids.empty?

    names = SlackChannel.where(uid: uids).pluck(:uid, :name).to_h

    purpose.gsub(CHANNEL_REFERENCE) do |reference|
      name = names[Regexp.last_match(1)]
      name ? "##{name}" : reference
    end
  end
end
