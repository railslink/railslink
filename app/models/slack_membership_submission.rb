class SlackMembershipSubmission < ApplicationRecord

  include Emailable
  include Nameable

  attr_accessor :fax
  attr_reader :approval_error

  enum status: [ :pending, :approved, :rejected, :ignored ]

  belongs_to :user, class_name: "SlackUser", 
    foreign_key: :slack_user_id,
    inverse_of: :membership_submission, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  # email is handled by Emailable concern
  validates :website_url, format: { with: %r{\Ahttps?://.*\.}, allow_blank: true }
  validates :github_url, format: { with: %r{\Ahttps?://github.com/}, allow_blank: true }
  validates :linkedin_url, format: { with: %r{\Ahttps?://(www\.)?linkedin.com/in/}, allow_blank: true }

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
    if e.message == "already_invited"
      approved!
      return true
    end

    raise e
  end
end
