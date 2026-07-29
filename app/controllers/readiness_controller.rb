# Readiness, as distinct from liveness. Rails' built-in "/up" deliberately touches
# nothing, so the proxy could mark a container healthy before Active Record had
# opened its first connection — leaving the first real visitor to pay connection
# setup plus the first render. This runs one bounded query so the deploy only cuts
# over once the app can actually serve a database-backed page.
#
# Inherits from ActionController::Base rather than ApplicationController to stay
# clear of session/auth callbacks.
class ReadinessController < ActionController::Base
  def show
    ActiveRecord::Base.connection.select_value("SELECT 1")
    head :ok
  rescue StandardError
    head :service_unavailable
  end
end
