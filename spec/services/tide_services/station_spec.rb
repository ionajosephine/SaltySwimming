require 'rails_helper'

RSpec.describe TideServices::Station do
  describe "#call" do
    let(:service) { described_class.new(station_id) }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/#{station_id}")
        .to_return(status: response_status, body: file_fixture("station.json"), headers: {"Content-Type" => "application/json"})
    end

    context "with real station record" do
      let(:station_id) { "0324" }
      let(:response_status) { 200 }

      it "returns a Station object with attributes" do
        expect(service.call).to be_kind_of(Station)
        expect(service.call.id).to eq("0324")
        expect(service.call.name).to eq("Rockall")
        expect(service.call.location).to eq([-13.683333, 57.6])
      end
    end

    context "with record not found" do
      let(:station_id) { "NOT_AN_ID" }
      let(:response_status) { 404 }

      it "returns a TideError" do
        expect { service.call }.to raise_error(TideServices::TideError) 
      end
    end
  end
end
