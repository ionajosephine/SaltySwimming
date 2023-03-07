require_relative 'base'

module TideServices
  class Station < Base

    def initialize(station_id)
      @station_id = station_id
    end
     
    def call
      response = make_request
      if response.success? 
          ::Station.new(
            name: response.body["properties"]["Name"],
            id: response.body["properties"]["Id"],
            location: response.body["geometry"]["coordinates"]
          )
      else
        raise TideError, "HTTP status #{response.status}"
      end
    end

    private

    def make_request
      conn.get("/uktidalapi/api/V1/Stations/#{@station_id}")
    end

  end
end