require 'rails_helper'

RSpec.describe "Stations", type: :feature do
  before do
    stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations")
      .to_return(status: 200, body: file_fixture("stations.json"), headers: {"Content-Type" => "application/json"})
    
    stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/0324")
      .to_return(status: 200, body: file_fixture("station.json"), headers: {"Content-Type" => "application/json"})
  
    stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations/0324/TidalEvents")
      .with(query: { duration: 7 })
      .to_return(status: 200, body: file_fixture("tides.json"), headers: {"Content-Type" => "application/json"})
    end

  it "displays the list of tidal stations" do
    visit stations_path
    within "h1" do
      expect(page).to have_content("Stations")
    end
    expect(page).to have_text("Hirta (Bagh A' Bhaile)")
    expect(page).to have_text("Rockall")
    expect(page).to have_text("Cargreen")
  end

  it "displays an individual tidal station with tides" do
    visit stations_path
    click_link("Rockall")
    expect(page).to have_current_path("/stations/0324")
    within "h1" do
      expect(page).to have_content("Station: Rockall")
    end
    expect(page).to have_text("HighWater")
    expect(page).to have_text("LowWater")
    expect(page).to have_text("Sun 5 Mar at 05:10")
    expect(page).to have_text("Tide Height: 2.6 metres")
  end
end

