class PagesController < ApplicationController
  def admin_members
    @admin_members = SlackUser.admins.active.sort_by_recent_activity
  end

  def code_of_conduct
    path = Rails.root.join("CODE_OF_CONDUCT.md")

    # The file only changes on deploy, but keying on mtime means a changed file is
    # picked up without waiting for a TTL. Re-parsing Kramdown per request was pure
    # waste.
    @coc_html = Rails.cache.fetch("pages/code_of_conduct/#{File.mtime(path).to_i}") do
      Kramdown::Document.new(File.read(path)).to_html
    end
  end
end
