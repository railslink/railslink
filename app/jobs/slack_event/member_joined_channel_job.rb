class SlackEvent::MemberJoinedChannelJob < ApplicationJob

  attr_reader :options
  private :options

  def perform(options = {})
    @options = options.with_indifferent_access
  end
end
