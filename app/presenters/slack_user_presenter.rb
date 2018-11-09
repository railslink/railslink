# frozen_string_literal: true

class SlackUserPresenter < BasePresenter
  def admin_checkmark
    is_admin? ? '✓' : ''
  end

  def name_with_email
    [name, email].select(&:present?).join(' - ')
  end

  def deleted_checkmark
    is_deleted? ? '✓' : ''
  end

  def bot_checkmark
    is_bot? ? '✓' : ''
  end
end
