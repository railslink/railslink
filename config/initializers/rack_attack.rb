Rack::Attack.blocklist("block invalid, bogus, requests") do |request|
  # Requests are blocked if the return value is truthy
  request.path.include?("/wp-login") ||
  request.path.include?("/wp-admin")
end
