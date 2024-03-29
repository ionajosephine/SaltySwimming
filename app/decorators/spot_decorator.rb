class SpotDecorator < Draper::Decorator
  delegate_all

  def preferred_tides
    if station
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
    tide_group = public_send("tides_#{method_name}")
    if tide_group.empty?
      {}
   else
      grouped_data = tide_group.group_by { |tide| tide.date_time&.to_date }
      remove_nil_keys(grouped_data)
    end
  end

  def weather
    @weather ||= Rails.cache.fetch("#{cache_key_with_version}/daily_weather", expires_in: 4.hours) do
      WeatherServices::Daily.new.call(latitude, longitude)
    end
  end

  def tides
    @tides ||= Rails.cache.fetch("#{cache_key_with_version}/tides", expires_in: 1.hour) do
      TideServices::Tides.new(station.admiralty_id).call
    end
  end

  def weather_emoji(date)
    if weather.present?
      weather.dig(date, :summary_emoji) 
    else
      "🧜‍♀️"
    end
  end


  private

  def remove_nil_keys(grouped_data)
    grouped_data.reject { |date, _| date.nil? }
  end
end
