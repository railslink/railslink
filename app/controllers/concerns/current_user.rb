module CurrentUser
  extend ActiveSupport::Concern

  included do
    before_action :reset_current_user
    helper_method :current_user
  end

  protected

  def current_user
    return unless session[:user_id]
    Thread.current[:current_user] ||= SlackUser.find_by(id: session[:user_id]).tap do |user|
      user.xoxp_token = session[:xoxp_token] if user
    end
  end

  def current_user=(user)
    if user
      session[:user_id] = user.id
      session[:xoxp_token] = user.xoxp_token
      Thread.current[:current_user] = user
    else
      session[:user_id] = nil
      session[:xoxp_token] = nil
      Thread.current[:current_user] = nil
    end
  end

  def reset_current_user
    Thread.current[:current_user] = nil
  end
end
