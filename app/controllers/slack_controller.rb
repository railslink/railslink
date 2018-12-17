class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :publish_event, only: [:event]
  before_action :verify_token!, only: [:event]

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

  def command
    list_admins if params[:command] == "admins"
  end

  protected

  def list_admins
    client = Slack::Web::Client.new
    admins = []
    response = client.users_list.members
    response.map { |user| admins << user.name if user.is_admin }
    render json: admins
  end

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
    params.require(:slack).permit!
  end
end
