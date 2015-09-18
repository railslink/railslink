class SlackApiResponse < ActiveRecord::Base

  # Returns latest valid API response.
  #
  # @param [String] method_name
  # @return [SlackApiResponse]
  def self.latest(method_name)
    self.where(method_name: method_name, ok: true
      ).order(updated_at: :desc).first
  end

  # Call API and save the response.
  #
  # @param [String] method_name
  # @param [Hash] payload
  # @return [SlackApiResponse]
  def self.fetch(method_name, payload)
    json = RestClient.post "https://slack.com/api/#{method_name}",
      payload, content_type: :json
    hash = JSON.parse(json)
    SlackApiResponse.create(
      method_name: method_name,
      ok: hash['ok'],
      response: hash,
    )
  end

end
