class SlackApiResponse < ActiveRecord::Base
  
  # Returns latest valid API response.
  #
  # @param [String] method_name
  # @return [SlackApiResponse]
  def self.latest(method_name)
    self.where(method_name: method_name, ok: true).order(updated_at: :desc).first
  end
  
  # Call API and save the response.
  #
  # @param [String] method_name
  # @param [Hash] payload
  # @return [SlackApiResponse]
  def self.fetch(method_name, payload)
    json = RestClient.post "https://slack.com/api/#{method_name}", payload, content_type: :json
    hash = JSON.parse(json)
    SlackApiResponse.create(
      method_name: method_name,
      ok: hash['ok'],
      response: hash,
    )
  end

  def self.channels
    @_channels ||= SlackApiResponse.latest('channels.list').response['channels']
  end

  def self.popular_channels(n = 6)
    channels.sort { |a, b| b['num_members'] <=> a['num_members'] }.first(6)
  end

  def self.members
    @_members ||= SlackApiResponse
                  .latest('users.list')
                  .response['members']
                  .select { |u| u['deleted'] == false }
  end

  def self.members_with_tz
    members.reject { |m| m['tz'].nil? }
  end

  # @timezones is a hash like
  # {
  #   'UTC-7': 70,
  #   'UTC-6': 54
  # }
  def self.tz_distribution
    @_tz_distribution ||= (-11..14).map do |num|
      [sprintf("UTC%+d", num), members_with_tz.count { |m| (m['tz_offset'] / 3600) == num }]
    end.to_h
  end

end
