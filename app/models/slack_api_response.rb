class SlackApiResponse < ActiveRecord::Base

  # Returns latest valid API response.
  #
  # @return [SlackApiResponse]
  def self.latest(api_name)
    self.where(method_name: api_name, ok: true).order(updated_at: :desc).first
  end

end
