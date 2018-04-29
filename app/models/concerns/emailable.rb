module Emailable
  extend ActiveSupport::Concern

  included do
    before_validation :sanitize_email
    validates :email, uniqueness: true
  end

  private

  def sanitize_email
    self.email = email.to_s.strip.downcase
    self.email = nil if email.blank?
  end
end
