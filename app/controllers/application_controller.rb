class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CurrentUser
  include Pagy::Backend
end
