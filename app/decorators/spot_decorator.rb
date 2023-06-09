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

  # Returns a hash of tides grouped by date. Example:
  # { 
  #   <#Date ...> => [ <#Tide ...>, <#Tide ...> ], 
  #   <#Date ...> => [ <#Tide ...>, <#Tide ...> ]
  # } 
  def grouped_tides(method_name)
    public_send("tides_#{method_name}").group_by { |tide| tide.date_time.to_date }
  end
end
