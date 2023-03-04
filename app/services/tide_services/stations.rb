require_relative 'base'

module TideServices
  class Stations < Base
    
    def call
      conn.get("/uktidalapi/api/V1/Stations")
    end

  end
end