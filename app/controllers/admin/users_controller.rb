# frozen_string_literal: true

class Admin::UsersController < AdminController
  def index
    @users = SlackUser.order(
      :is_deleted,
      { is_admin: :desc },
      :last_name,
      :email
    )

    @users = SlackUserPresenter.from_collection(@users)
  end

  def show
    @user = SlackUser.find(params[:id])
  end
end
