require_relative 'base'

module TideServices
  class Tides < Base

    def initialize(station_id)
      @station_id = station_id
    end

    def call
      conn.get("/uktidalapi/api/V1/Stations/#{@station_id}/TidalEvents", { duration: 7 })
    end

  end
end