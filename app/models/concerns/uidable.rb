module Uidable
  extend ActiveSupport::Concern

  included do
    validates :uid, presence: true, uniqueness: true
  end
end
