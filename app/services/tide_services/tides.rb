require_relative 'base'

module TideServices
  class Tides < Base

    def initialize(station_id)
      @station_id = station_id
    end

    # TODO: return an array of Tide objects

    def call
      response = make_request
      if response.success?
        response.body.map do |tideEvent|
          ::Tide.new(
            event: tideEvent["EventType"],
            # Needs turning into a proper date format - perhaps some sort of helper or decorator method?
            date_time: DateTime.parse(tideEvent["DateTime"]),
            height: tideEvent["Height"].round(1)
          )
        end
      else
        raise TideError, "HTTP status #{response.status}"
      end
    end

    def make_request
      conn.get("/uktidalapi/api/V1/Stations/#{@station_id}/TidalEvents", { duration: 7 })
    end

  end
end