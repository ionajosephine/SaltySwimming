require 'rails_helper'

RSpec.describe TideServices::Tides do
  describe "#call" do
    let(:service) { described_class.new(station_id) }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/#{station_id}/TidalEvents")
        .with(query: { duration: 7 })
        .to_return(status: response_status, body: "[]", headers: {"Content-Type" => "application/json"})
    end

    context "with real station record" do
      let(:station_id) { "0547" }
      let(:response_status) { 200 }

      it "returns a 200 success response" do
        expect(service.call.status).to eq(200)
      end

      it "returns an array" do 
        expect(service.call.body).to be_kind_of(Array)
      end
    end

    context "with record not found" do
      let(:station_id) { "NotAnId" }
      let(:response_status) { 404 }

      it "returns a 404 status" do
        expect(service.call.status).to eq(404)
      end
    end
  end
end
