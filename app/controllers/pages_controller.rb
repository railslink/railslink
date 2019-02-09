class PagesController < ApplicationController
  def admin
    @admin_members = SlackUser.admins
  end
end
