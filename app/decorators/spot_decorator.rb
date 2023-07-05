class SpotDecorator < Draper::Decorator
  delegate_all

  def preferred_tides
    if station 
      tides = TideServices::Tides.new(station.admiralty_id).call
      if condition == "both"
        tides
      else
        tides.select { |tide| tide.event.underscore == condition }
      end
    else
      []
    end
  end


  

  def tides_today
    preferred_tides.select { |tide| tide.date_time.present? && tide.date_time.today? }
  end

  def tides_tomorrow
    preferred_tides.select { |tide| tide.date_time.present? && tide.date_time.tomorrow? }
  end

  def tides_today_and_tomorrow
    preferred_tides.select { |tide| tide.date_time.present? && (tide.date_time.today? || tide.date_time.tomorrow?) }
  end

  def tides_seven_days
    preferred_tides
  end

  def grouped_tides(method_name)
    tides = public_send("tides_#{method_name}")
    if tides.empty?
      {}
   else
      grouped_data = tides.group_by { |tide| tide.date_time&.to_date }
      remove_nil_keys(grouped_data)
    end
  end

  def daily_weather_summary(latitude, longitude)
    weather_response = WeatherServices::Daily.new.call(latitude, longitude).body
  
    {
      daily_weather: weather_response["features"].first["properties"],
      weather_by_date: daily_weather(weather_response["features"].first["properties"]["timeSeries"]),
      # weather_station_name: weather_response["location"]["name"]
    }
  end
  

  private

  def daily_weather(time_series)
    result = {}
    time_series.each do |day|
      result[day["time"].to_date] = {
        max_temp: day["dayMaxScreenTemperature"].round,
        lowest_feels: day["dayLowerBoundMaxFeelsLikeTemp"].round,
        highest_feels: day["dayUpperBoundMaxFeelsLikeTemp"].round,
        summary_emoji: emoji_summary(day["daySignificantWeatherCode"])
      }
    end
    result
  end

  def remove_nil_keys(grouped_data)
    grouped_data.reject { |date, _| date.nil? }
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


end
