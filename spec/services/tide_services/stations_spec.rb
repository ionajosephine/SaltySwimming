require 'rails_helper'

RSpec.describe TideServices::Stations do
  describe "#call" do
    let(:service) { described_class.new }

    before do
      stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations")
        .to_return(status: 200, body: file_fixture("stations.json"), headers: {"Content-Type" => "application/json"})
    end
    
    context "when no records exist" do
      it "creates all stations in the database" do
        expect { service.call }.to change { Station.count }.by(3)
      end

      it "creates a record with the correct attributes" do
        service.call
        record = Station.last
        expect(record.name).to eq("Cargreen")
        expect(record.latitude).to eq(50.45)
        expect(record.longitude).to eq(-4.2)
        expect(record.admiralty_id).to eq("0014B")
      end
    end

    context "when one record already exists" do
      before do
        FactoryBot.create(:station, admiralty_id: "0322")
      end

      it "creates only 2 stations in the database" do
        expect { service.call }.to change { Station.count }.by(2)
      end
    end
  end
end
