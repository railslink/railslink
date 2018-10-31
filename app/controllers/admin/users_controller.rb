class Admin::UsersController < AdminController
  def index
    @users = SlackUser.order(:is_deleted).order(is_admin: :desc).order(:last_name, :email)
  end
  def show
    @user = SlackUser.find(params[:id])
  end
end
