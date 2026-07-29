module Emailable
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_email
    # allow_nil, because sanitize_email nils out blanks and Slack members
    # without an email (bots, deactivated, restricted) are legitimately many.
    # Without it only the first null-email record can ever be saved.
    validates :email, uniqueness: true, allow_nil: true
  end

  private

  def sanitize_email
    self.email = email.to_s.strip.downcase
    self.email = nil if email.blank?
  end
end
