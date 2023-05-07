require 'faraday'

module TideServices
  class Base
    URL = "https://admiraltyapi.azure-api.net"
    HEADERS = { 'Ocp-Apim-Subscription-Key' => Rails.application.credentials.admiralty_api_key }

    private

    def conn
      Faraday.new(url: URL, headers: HEADERS) do |f|
        f.response :json
      end
    end
  end 
end