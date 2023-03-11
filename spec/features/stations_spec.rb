require 'rails_helper'

RSpec.describe "Stations", type: :feature do
  before do
    stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/#{station1.admiralty_id}/TidalEvents")
      .with(query: { duration: 7 })
      .to_return(status: 200, body: file_fixture("tides.json"), headers: {"Content-Type" => "application/json"})
    end
  
  let!(:station1) { FactoryBot.create(:station) }
  let!(:station2) { FactoryBot.create(:station) }


  it "displays the list of tidal stations" do
    visit stations_path
    within "h1" do
      expect(page).to have_content("Stations")
    end
    expect(page).to have_text(station1.name)
    expect(page).to have_text(station2.name)
  end

  it "displays an individual tidal station with tides" do
    visit stations_path
    click_link(station1.name)
    expect(page).to have_current_path(station_path(station1))
    within "h1" do
      expect(page).to have_content("Station: #{station1.name}")
    end
    expect(page).to have_text("HighWater")
    expect(page).to have_text("LowWater")
    expect(page).to have_text("Sun 5 Mar at 05:10")
    expect(page).to have_text("Tide Height: 2.6 metres")
  end
end

