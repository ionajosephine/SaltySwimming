class SpotDecorator < Draper::Decorator
  delegate_all

  def preferred_tides
    if station 
      tides = TideServices::Tides.new(station.admiralty_id).call
      tides.select { |tide| tide.event.underscore == condition }
    else
      []
    end
  end

  def tides_today
    preferred_tides.select { |tide| tide.date_time.today? }
  end

  def tides_tomorrow
    preferred_tides.select { |tide| tide.date_time.tomorrow? }
  end

  def tides_today_and_tomorrow
    preferred_tides.select { |tide| tide.date_time.today? || tide.date_time.tomorrow? }
  end

  def tides_seven_days
    preferred_tides
  end







end
