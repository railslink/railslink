class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CurrentUser
  include Pagy::Backend

  # Can't use Rails.env here as both the dev and prod sites run as production.
  def is_railslink_dev_heroku?
    request.host == "railslink-dev.herokuapp.com"
  end
end
