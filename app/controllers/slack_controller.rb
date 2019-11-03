class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :publish_event
  before_action :verify_token!

  # see https://api.slack.com/events-api
  # see https://api.slack.com/events/url_verification
  def event
    if slack_params[:type] == "url_verification"
      render plain: slack_params[:challenge]
      return
    end

    SlackEvent::UnhandledJob.perform_later(slack_params.to_hash) if is_railslink_dev_heroku?

    case slack_params.fetch(:event, {})[:type]
    when "admins"
      SlackEvent::AdminsJob.perform_later(slack_params.to_hash)
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

  def publish_event
    REDIS.publish(:slack_events, slack_params.to_json)
  rescue StandardError => e
    Rollbar.error(e, :slack_params => slack_params.to_hash)
  end

  def verify_token!
    return if slack_params[:token] == ENV["SLACK_VERIFICATION_TOKEN"]
    head :forbidden
    return
  end

  def slack_params
    params[:slack][:token] = params[:token] if params[:token]
    params[:slack][:response_url] = params[:response_url] if params[:response_url]
    params.require(:slack).permit!
  end
end
