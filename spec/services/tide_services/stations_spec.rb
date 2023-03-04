require 'rails_helper'

RSpec.describe TideServices::Stations do
  describe "#call" do
    let(:service) { described_class.new }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations")
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})
    end

    it "returns a 200 success response" do 
      expect(service.call.status).to eq(200)
    end

    it "returns a ruby hash" do
      expect(service.call.body).to be_kind_of(Hash)
    end
  end
end
