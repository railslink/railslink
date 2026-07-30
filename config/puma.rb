# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Warm the render path once the server is listening.
#
# "/readyz" proves the database is reachable, but the first request to "/" also
# pays Slim template compilation and view warmup — measured at ~7.3s cold against
# ~1.0-2.0s warm, with the DB connection already established. Only an actual render
# clears that, so self-request "/" here and let the deploy absorb the cost instead
# of the first real visitor.
#
# Runs in a background thread so boot is never blocked, and swallows everything:
# a failed warmup should cost us a slow first page, never the process.
on_booted do
  next unless ENV.fetch("RAILS_ENV", "development") == "production"

  Thread.new do
    require "net/http"

    # config.assume_ssl is on and host authorization is disabled, so a plain
    # request to the loopback address renders rather than redirecting to https.
    http = Net::HTTP.new("127.0.0.1", ENV.fetch("PORT", 3000).to_i)
    http.open_timeout = 5
    http.read_timeout = 60

    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response = http.get("/")
    elapsed = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(2)

    puts "[warmup] GET / -> #{response.code} in #{elapsed}s"
  rescue StandardError => e
    puts "[warmup] skipped: #{e.class}: #{e.message}"
  end
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
