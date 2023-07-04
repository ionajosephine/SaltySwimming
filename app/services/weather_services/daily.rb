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





#     def fetch_forecast(location)
#       response = conn.get("/weather/forecast/#{location}")

#       if response.status == 200
#         forecast_data = JSON.parse(response.body)
#         # Process the forecast data here
#         # ...
#       else
#         # Handle the API error response
#         puts "API error: #{response.status}"
#       end
#     end

    
#   end
# end

# module WeatherServices
#   class Base
#     BASE_URL = "https://api-metoffice.apiconnect.ibmcloud.com/v0"

#     def fetch_forecast(latitude, longitude)
#       url = "#{BASE_URL}/forecasts/point/daily"
#       params = {
#         latitude: latitude,
#         longitude: longitude,
#         excludeParameterMetadata: false,
#         includeLocationName: true
#       }

#       response = conn.get(url, params)

#       if response.status == 200
#         forecast_data = JSON.parse(response.body)
#         # Process the forecast data here
#         # ...
#       else
#         # Handle the API error response
#         puts "API error: #{response.status}"
#       end
#     end

    
#   end
# end

