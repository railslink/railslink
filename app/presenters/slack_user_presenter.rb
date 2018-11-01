# frozen_string_literal: true

class SlackUserPresenter < BasePresenter
  def admin_checkmark
    is_admin? ? '✓' : ''
  end
end
