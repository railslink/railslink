# frozen_string_literal: true

class SlackChannelPresenter < BasePresenter
  def cleaned_purpose
    return "" if purpose.blank?

    purpose.gsub(/<#(C\w+)\|([^>]+)>/, '#\2')
  end
end
