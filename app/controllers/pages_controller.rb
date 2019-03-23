class PagesController < ApplicationController
  def admin_members
    @admin_members = SlackUser.admins.active.sort_by_recent_activity
  end

  def code_of_conduct
    text = File.read(File.join(Rails.root, "CODE_OF_CONDUCT.md"))
    @coc_html = Kramdown::Document.new(text).to_html
  end
end
