class ApplicationController < ActionController::Base
  include CurrentUser
  include Pagy::Backend
end
