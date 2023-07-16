require 'faraday'
require_relative 'base'

module WeatherServices
  class Daily < Base
    def call(latitude, longitude)
      response = make_request(latitude, longitude)
      if response.success? 
        parse(response.body)
      else
        Rails.logger.info("Met Office API error HTTP status #{response.status}")
        {}
        
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

    def parse(response)
      time_series = response.dig("features")&.first&.dig("properties", "timeSeries") || []

      result = {}
      time_series.each do |day|
        result[day["time"].to_date] = {
          max_temp:       day["dayUpperBoundMaxTemp"]&.round || "n/a",
          min_temp:       day["nightLowerBoundMinTemp"]&.round || "n/a",
          lowest_feels:   day["dayLowerBoundMaxFeelsLikeTemp"]&.round || "n/a",
          highest_feels:  day["dayUpperBoundMaxFeelsLikeTemp"]&.round || "n/a",
          wind_direction: day["midday10MWindDirection"].present? ? wind_direction(day["midday10MWindDirection"]) : "n/a",
          wind_speed:     day["midday10MWindSpeed"].present? ? ms_to_mph(day["midday10MWindSpeed"]).round : "n/a",
          wind_gust:      day["midday10MWindGust"].present? ? ms_to_mph(day["midday10MWindGust"]).round : "n/a",
          precipitation:  day["dayProbabilityOfPrecipitation"] || "n/a",
          summary_emoji:  emoji_summary(day["daySignificantWeatherCode"])
        }
      end
      result
    end

    def emoji_summary(code)
      case code
      when -1
        "Probably won't rain ☔️"
      when 0
        "Clear night 🌙"
      when 1
        "Sunny day ☀️"
      when 2
        "Partly cloudy night 🌑⛅️"
      when 3
        "Partly cloudy 🌤"
      when 5
        "Mist 🌫"
      when 6
        "Fog 🌁"
      when 7
        "Cloudy ☁️"
      when 8
        "Overcast ☁️"
      when 9
        "Light rain shower night 🌧"
      when 10
        "Light rain showers 🌧"
      when 11
        "Drizzle 🌧"
      when 12
        "Light rain 🌧"
      when 13
        "Heavy rain shower (night) ⛈"
      when 14
        "Heavy rain showers ⛈"
      when 15
        "Heavy rain 🌧"
      when 16
        "Sleet shower (night) 🌨"
      when 17
        "Sleet shower 🌨"
      when 18
        "Sleet 🌨"
      when 19
        "Hail shower (night) 🌧❄️"
      when 20
        "Hail showers 🌧❄️"
      when 21
        "Hail ❄️"
      when 22
        "Light snow shower (night) ❄️"
      when 23
        "Light snow showers ❄️"
      when 24
        "Light snow ❄️"
      when 25
        "Heavy snow shower (night) ❄️⛄️"
      when 26
        "Heavy snow showers ❄️⛄️"
      when 27
        "Heavy snow ❄️⛄️"
      when 28
        "Thunder shower (night) ⚡️🌧"
      when 29
        "Thunder shower ⚡️🌧"
      when 30
        "Thunder ⚡️"
      else
        "Not available ❓"
      end
    end
  
    def wind_direction(degrees)
      directions = %w[N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW]
      index = ((degrees % 360) / 22.5).round
      directions[index]
    end

    def ms_to_mph(ms)
      mph = (ms * 2.2)
    end

  end
end
