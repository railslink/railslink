# == Schema Information
#
# Table name: slack_membership_submissions
#
#  id            :bigint           not null, primary key
#  slack_user_id :bigint
#  status        :integer          default("pending")
#  first_name    :string
#  last_name     :string
#  email         :string
#  location      :string
#  introduction  :text
#  how_hear      :text
#  linkedin_url  :string
#  github_url    :string
#  website_url   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ip_address    :inet
#
class SlackMembershipSubmission < ApplicationRecord

  include Emailable
  include Nameable

  attr_accessor :fax
  attr_reader :approval_error

  enum :status, { pending: 0, approved: 1, rejected: 2, ignored: 3 }

  belongs_to :user, class_name: "SlackUser", 
    foreign_key: :slack_user_id,
    inverse_of: :membership_submission, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  # email is handled by Emailable concern
  validates :website_url, format: { with: %r{\Ahttps?://.*\.}, allow_blank: true }
  validates :github_url, format: { with: %r{\Ahttps?://github.com/}, allow_blank: true }
  validates :linkedin_url, format: { with: %r{\Ahttps?://(www\.)?linkedin.com/in/}, allow_blank: true }
  validates :introduction, presence: true
  validates :how_hear, presence: true

  scope :chronologically, -> { order(:created_at) }

  def approve_and_invite!
    client = Slack::Web::Client.new(token: Thread.current[:current_user].xoxp_token)
    res = client.users_admin_invite(
      email: email,
      first_name: first_name,
      last_name: last_name,
      resend: true,
      channels: SlackChannel.defaults.pluck(:uid).join(",")
    )
    if res["ok"]
      approved!
      true
    else
      @approval_error = res
      false
    end
  rescue Slack::Web::Api::Errors::SlackError => e
    if %w[already_invited already_in_team sent_recently].include?(e.message)
      approved!
      return true
    end

    raise e
  end

  def ip_address_location
    return if ip_address.nil?
    ii = IpInfo.new(ip_address.to_s)
    return unless ii.successful?
    [ii.city, ii.region, ii.country].join(", ")
  end
end
