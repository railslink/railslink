class SessionsController < ApplicationController
  def setup
    if params[:require] == "admin"
      request.env["omniauth.strategy"].options["scope"] = "client" 
    end
    render plain: "", status: 404
  end

  def create
    user = SlackUser.find_or_create_from_auth_hash(request.env["omniauth.auth"])
    self.current_user = user
    if request.env["omniauth.params"]["require"] == "admin" && current_user.is_admin?
      redirect_to admin_path
    else
      redirect_to root_path
    end
  end

  def failure
    flash[:warning] = "Unable to authenticate to #{params[:strategy].titleize}. #{params[:message].humanize}."
    redirect_to root_path
  end

  def new
    redirect_to "/auth/slack"
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end
end
