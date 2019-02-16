class PagesController < ApplicationController
  def admin_members
    @admin_members = SlackUser.admins.active.sort_by_recent_activity
  end
end
