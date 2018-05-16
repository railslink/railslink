class ApplicationJob < ActiveJob::Base
  queue_as :default

  around_perform :with_connection_pool

  private

  # https://github.com/brandonhilkert/sucker_punch/#activerecord-connection-pool-connections
  def with_connection_pool
    ActiveRecord::Base.connection_pool.with_connection do
      yield
    end
  end
end
