class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token!

  # see https://api.slack.com/events-api
  # see https://api.slack.com/events/url_verification
  def event
    render plain: params[:challenge]
  end

  protected

  def verify_token!
    return if params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
    head :forbidden
    return
  end
end
