require 'faraday'
require_relative 'base'

module WeatherServices
  class Daily < Base
    def call(latitude, longitude)
      response = make_request(latitude, longitude)
      if response.success? 
        response
      else
        Rails.logger.info("Met Office API error HTTP status #{response.status}")
        response
      end
    end

    def make_request(latitude, longitude)
      conn.get("forecasts/point/daily", {
        latitude: latitude,
        longitude: longitude,
        excludeParameterMetadata: false,
        includeLocationName: true
      })
    end

  end
end
