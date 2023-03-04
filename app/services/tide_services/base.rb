require 'faraday'

module TideServices
  class Base
    URL = "https://admiraltyapi.azure-api.net"
    HEADERS = {'Ocp-Apim-Subscription-Key' => '722f777d942c41669037da3005ed64e0'}

    private

    def conn
      Faraday.new(url: URL, headers: HEADERS) do |f|
        f.response :json
      end
    end
  end 
end