require 'rails_helper'

RSpec.describe TideServices::Stations do
  describe "#call" do
    let(:service) { described_class.new }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations")
        .to_return(status: 200, body: file_fixture("stations.json"), headers: {"Content-Type" => "application/json"})
    end

    it "returns 3 objects" do
      expect(service.call.length).to eq(3)
    end

    it "returns Station instances with attributes" do
      station = service.call.first
      expect(station).to be_kind_of(Station)
      expect(station.id).to eq("0322")
      expect(station.name).to eq("Hirta (Bagh A' Bhaile)")
      expect(station.location).to eq([-8.566666, 57.8])
    end
  end
end
