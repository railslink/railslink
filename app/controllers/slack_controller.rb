class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_token!

  # see https://api.slack.com/events-api
  # see https://api.slack.com/events/url_verification
  def event
    if slack_params[:type] == "url_verification"
      render plain: slack_params[:challenge]
      return
    end

    case slack_params.fetch(:event, {})[:type]
    when "message"
      SlackEvent::MessageJob.perform_later(slack_params.to_hash)
    when "member_joined_channel"
      SlackEvent::MemberJoinedChannelJob.perform_later(slack_params.to_hash)
    when "team_join"
      SlackEvent::TeamJoinJob.perform_later(slack_params.to_hash)
    else
      SlackEvent::UnhandledJob.perform_later(slack_params.to_hash)
    end

    head :ok
  end

  protected

  def verify_token!
    return if slack_params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
    head :forbidden
    return
  end

  def slack_params
    params.require(:slack).permit!
  end
end
