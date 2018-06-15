module Helpers
  def authorize_admin!
    allow(@controller).to receive(:require_admin!).and_return(true)
  end
end