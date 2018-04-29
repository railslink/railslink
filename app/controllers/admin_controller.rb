class AdminController < ApplicationController
  before_action :require_admin!

  protected

  def require_admin!
    return if current_user && current_user.is_admin?
    redirect_to "/auth/slack?require=admin" and return unless current_user
    redirect_to root_path and return
  end
end
