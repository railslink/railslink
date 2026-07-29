#
# See http://ip-api.com/docs/api:json
#
class IpInfo
  SUCCESS_TTL = 30.days
  FAILURE_TTL = 5.minutes
  TIMEOUT = 3

  def initialize(ip_address)
    @ip_address = ip_address
    @info = cached_info
  end

  def successful?
    @info["status"] == "success"
  end

  def method_missing(symbol, *args)
    key = symbol.to_s.camelize(:lower)
    return @info[key] if @info.key?(key)
    super
  end

  def respond_to_missing?(symbol, include_private = false)
    @info.key?(symbol.to_s.camelize(:lower)) || super
  end

  private

  # A given IP resolves to the same place for a long time, and this is called
  # while rendering the admin pending-submission page — uncached it added up to
  # TIMEOUT seconds to every render. Failures are cached only briefly so a blip
  # at the provider doesn't stick around for a month.
  def cached_info
    key = "ip_info/#{@ip_address}"
    cached = Rails.cache.read(key)
    return cached if cached

    fetch_info.tap do |info|
      ttl = info["status"] == "success" ? SUCCESS_TTL : FAILURE_TTL
      Rails.cache.write(key, info, expires_in: ttl)
    end
  end

  def fetch_info
    Timeout::timeout(TIMEOUT) do
      JSON.parse(Net::HTTP.get("ip-api.com", "/json/#{@ip_address}"))
    end
  rescue Net::OpenTimeout, JSON::ParserError, Timeout::Error
    {}
  end
end
