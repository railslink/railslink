# frozen_string_literal: true

class BasePresenter < SimpleDelegator
  attr_reader :view

  def initialize(model, view = ActionView::Base.empty)
    @view = view
    super(model)
  end

  def self.from_collection(collection, view = ActionView::Base.empty)
    collection.map { |model| new(model, view) }
  end

  def model
    __getobj__
  end
end
