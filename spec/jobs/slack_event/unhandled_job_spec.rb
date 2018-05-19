require 'rails_helper'

RSpec.describe SlackEvent::UnhandledJob, type: :job do
  let(:options) { { event: { foo: "bar", one: 1 }} }

  describe "#perform" do
    it "stores the options in redis" do
      subject.perform(options)
      expect(REDIS.rpop("slack_event:unhandled_jobs")).to eq options.to_json
    end

    it "prunes the redis list" do
      stub_const("SlackEvent::UnhandledJob::MAX_LIST_SIZE", 2)
      3.times { subject.perform(options) }
      expect(REDIS.llen("slack_event:unhandled_jobs")).to eq 2
    end
  end
end
