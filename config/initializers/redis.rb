REDIS = if ENV["REDIS_CLOUD_URL"].present?
          Redis.new(url: ENV["REDIS_CLOUD_URL"])
        else
          Redis.new
        end
