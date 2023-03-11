require_relative 'base'

module TideServices
  class Stations < Base
    
    def call
      response = make_request
      if response.success? 
        response.body["features"].map do |feature|
          ::Station.new(
            name: feature["properties"]["Name"],
            id: feature["properties"]["Id"],
            location: feature["geometry"]["coordinates"]
          )
        end
      else 
        raise TideError, "HTTP status #{response.status}"
      end
    end

    private

    def make_request
      conn.get("/uktidalapi/api/V1/Stations")
    end

  end
end
