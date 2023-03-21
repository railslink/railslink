# == Schema Information
#
# Table name: slack_users
#
#  id              :bigint           not null, primary key
#  uid             :string
#  email           :string
#  username        :string
#  first_name      :string
#  last_name       :string
#  tz              :string
#  tz_offset       :integer
#  locale          :string
#  is_deleted      :boolean
#  is_admin        :boolean
#  is_bot          :boolean
#  data            :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_message_at :datetime
#  pronouns        :string
#
class SlackUser < ApplicationRecord

  include Uidable
  include Emailable
  include Nameable

  attr_accessor :xoxp_token

  has_one :membership_submission, class_name: "SlackMembershipSubmission"

  scope :deleted, -> { where(is_deleted: true) }
  scope :extant, -> { where(is_deleted: false) }
  scope :admins, -> { where(is_admin: true) }
  scope :bots, -> { where(is_bot: true) }
  scope :human, -> { where(is_bot: false) }
  scope :available, -> { extant.human }
  scope :active, -> { available.where.not(last_message_at: nil) }
  scope :sort_by_recent_activity, -> { order(last_message_at: :desc) }

  def self.find_or_create_from_auth_hash(auth_hash)
    user = find_or_create_from_api_response(auth_hash.extra.user_info.user)
    user.xoxp_token = auth_hash.credentials.token
    user
  end

  def self.find_or_create_from_api_response(data)
    user = find_by(uid: data.id) || new
    user.update(
      uid: data.id,
      username: data.name,
      email: data.profile.email,
      first_name: data.profile.first_name,
      last_name: data.profile.last_name,
      tz: data.tz,
      tz_offset: data.tz_offset,
      locale: data.locale,
      is_deleted: data.deleted,
      is_admin: data.is_admin,
      is_bot: data.is_bot,
      data: data
    )
    user
  end

  def self.tz_offset_distribution
    results = where.not(tz_offset: nil).group("tz_offset / 3600")
      .count
      .sort
      .map {|k, v| [sprintf("UTC%+d", k), v]}
    Hash[results]
  end
end
