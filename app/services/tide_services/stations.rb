require_relative 'base'

module TideServices
  class Stations < Base
    
    def call
      response = make_request
      if response.success? 
        response.body["features"].each do |feature|
          unless ::Station.exists?(admiralty_id: feature["properties"]["Id"])
            ::Station.create!(
              admiralty_id: feature["properties"]["Id"],
              name: feature["properties"]["Name"],
              latitude: feature["geometry"]["coordinates"][1],
              longitude: feature["geometry"]["coordinates"][0]
            )
          end
        end
        return true
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
