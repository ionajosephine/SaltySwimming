require_relative 'base'

module TideServices
  class Station < Base

    def initialize(station_id)
      @station_id = station_id
    end
    
    def call
      conn.get("/uktidalapi/api/V1/Stations/#{@station_id}")
    end

  end
end