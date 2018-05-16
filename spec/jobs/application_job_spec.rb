require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it "it wraps the job in AR's connection pool" do
    class SampleWorker < ApplicationJob
      def perform
        true
      end
    end

    expect(ActiveRecord::Base).to receive_message_chain(:connection_pool, :with_connection).and_yield
    SampleWorker.perform_now
  end
end
