module ApplicationHelper
  def link_to_login_or_logout
    if current_user
      link_to "Logout", logout_path, class: "navbar-item"
		else
      # TODO: abstract the hardcoded url
      link_to "Login", "/auth/slack", class: "navbar-item"
    end
  end

  def link_to_open_slack
    id = SlackChannel.where(is_general: true).first.uid
    team = ENV["SLACK_TEAM"]
    link_to "Open Slack", "slack://channel?id=#{id}&team=#{team}", class: "navbar-item"
  end

  def in_admin_space?
    controller_path.starts_with?("admin/")
  end

  def is_homepage?
    controller_name == "home" && action_name == "index"
  end
end
