require 'rails_helper'

RSpec.describe TideServices::Tides do
  describe "#call" do
    let(:service) { described_class.new(station_id) }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/#{station_id}/TidalEvents")
        .with(query: { duration: 7 })
        .to_return(status: response_status, body: file_fixture("tides.json"), headers: {"Content-Type" => "application/json"})
    end

    context "with real station record" do
      let(:station_id) { "0547" }
      let(:response_status) { 200 }

      it "returns Tide objects with attributes" do
        tide = service.call.first
        expect(tide.event).to eq("HighWater")
        expect(tide.height).to eq(2.6)
        expect(tide.date_time).to eq(DateTime.parse("2023-03-05T05:10:00"))
      end

      it "returns an array" do 
        expect(service.call).to be_kind_of(Array)
      end
    end

    context "with record not found" do
      let(:station_id) { "NotAnId" }
      let(:response_status) { 404 }

      it "returns a TideError" do
        expect { service.call }.to raise_error(TideServices::TideError)
      end
    end
  end
end
