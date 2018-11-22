class SlackChannel < ApplicationRecord

  include Uidable

  DEFAULT_CHANNELS = %w[announcements coding frontend introductions random share work-offers]

  scope :available, -> { where(is_private: false, is_archived: false) }
  scope :popular, -> { order(members_count: :desc) }
  scope :defaults, -> { where(name: DEFAULT_CHANNELS) }

  def self.find_or_create_from_api_response(data)
    channel = find_by(uid: data.id) || new
    channel.update(
      uid: data.id,
      name: data.name,
      is_archived: data.is_archived,
      is_general: data.is_general,
      is_private: data.is_private,
      purpose: data.purpose.value,
      members_count: data.num_members,
      created_at: Time.at(data.created),
      data: data
    )
    channel
  end

  def name_with_hash
    "##{name}"
  end
end
