require_relative 'base'

module TideServices
  class Tides < Base

    def initialize(station_id)
      @station_id = station_id
    end

    def call
      response = make_request
      if response.success?
        response.body.map do |tideEvent|
          ::Tide.new(
            event: tideEvent["EventType"],
            # Needs turning into a proper date format - perhaps some sort of helper or decorator method?
            date_time: convert_to_uk_time(tideEvent["DateTime"]),
            height: tideEvent["Height"].round(1)
          )
        end
      else
        raise TideError, "HTTP status #{response.status}"
        raise TideError.new("HTTP status #{response.status}")
      end
    end

    def make_request
      conn.get("/uktidalapi/api/V1/Stations/#{@station_id}/TidalEvents", { duration: 7 })
    end

    def convert_to_uk_time(datetime)
      parsed_time = DateTime.parse(datetime)
      uk_time = parsed_time.in_time_zone('London')
      uk_time
    end
  end
end