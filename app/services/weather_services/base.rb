require 'faraday'

module WeatherServices
  class Base
    URL = "https://api-metoffice.apiconnect.ibmcloud.com/v0/"
    HEADERS = { 
      # NB: the X_IBM_Client_Id and Secret are specific to the daily forecast for now
      'X-IBM-Client-Id' => Rails.application.credentials.x_ibm_client_id,
      'X-IBM-Client-Secret' => Rails.application.credentials.x_ibm_client_secret
    }

    private

    def conn
      Faraday.new(url: URL, headers: HEADERS) do |f|
        f.response :json
      end
    end
  end 
end

