module Nameable
  extend ActiveSupport::Concern

  def name
    [first_name, last_name].join(" ").squeeze(" ").strip
  end
end
