namespace :slack do

  desc "Sync everything"
  task sync: ["sync:channels", "sync:users"] do
  end

  namespace :sync do
    desc "Sync channels"
    task channels: [:environment] do
      puts "Syncing slack channels..."
      failures = []
      begin
        client = Slack::Web::Client.new
        client.conversations_list do |response|
          response.channels.each do |channel|
            puts " - #{channel["name"]}"
            record = SlackChannel.find_or_create_from_api_response(channel)
            failures << report_failure(channel["name"], record)
          end
        end
      rescue Faraday::ConnectionFailed => e
        raise(e) unless e.message =~ /execution expired/
        puts " - #{e.class}: #{e.message}"
      end
      abort_on_failures("channels", failures.compact)
    end

    desc "Sync users"
    task users: [:environment] do
      puts "Syncing slack users..."
      failures = []
      skipped = 0
      begin
        client = Slack::Web::Client.new
        client.users_list(include_locale: true) do |response|
          response.members.each do |member|
            if unchanged_since_last_sync?(member)
              skipped += 1
              next
            end

            puts " - #{member["name"]}"
            record = SlackUser.find_or_create_from_api_response(member)
            failures << report_failure(member["name"], record)
          end
        end
      rescue Faraday::ConnectionFailed => e
        raise(e) unless e.message =~ /execution expired/
        puts " - #{e.class}: #{e.message}"
      end
      puts "Skipped #{skipped} unchanged users." if skipped.positive?
      abort_on_failures("users", failures.compact)
    end
  end
end

# Slack stamps each user payload with an `updated` epoch. Re-writing all ~38k
# members on every run when almost none have changed is pure waste, so compare
# against what we stored last time and skip the no-ops. A member we have never
# seen, or one with no stamp, always syncs.
def unchanged_since_last_sync?(member)
  stamp = member["updated"]
  return false if stamp.blank?

  existing = SlackUser.find_by(uid: member["id"])
  return false if existing.nil?

  existing.data.is_a?(Hash) && existing.data["updated"] == stamp
end

# find_or_create_from_api_response returns the record whether or not it saved,
# so an unsaved record is the only signal that Slack data was rejected. Report
# it per-record and keep going, then fail the task at the end — a sync that
# silently drops rows looks successful while never making progress.
def report_failure(name, record)
  return nil if record&.persisted? && record.errors.empty?

  reason = record ? record.errors.full_messages.join(", ") : "record was nil"
  puts "   ! FAILED #{name}: #{reason}"
  name
end

def abort_on_failures(kind, failures)
  return puts("Synced slack #{kind}.") if failures.empty?

  abort "#{failures.size} slack #{kind} failed to sync: #{failures.join(", ")}"
end
