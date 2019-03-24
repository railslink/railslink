# 
# See http://ip-api.com/docs/api:json
#
class IpInfo
  def initialize(ip_address)
    @ip_address = ip_address
    @info = JSON.parse(Net::HTTP.get("ip-api.com", "/json/#{@ip_address}"))
  end

  def successful?
    @info["status"] == "success"
  end

  def method_missing(symbol, *args)
    key = symbol.to_s.camelize(:lower)
    return @info[key] if @info.key?(key)
    super
  end
end
