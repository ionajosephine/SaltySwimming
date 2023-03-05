require 'rails_helper'

RSpec.describe "Stations", type: :feature do
  before do
    stub_request(:get, "https://admiraltyapi.azure-api.net/uktidalapi/api/V1/Stations")
      .to_return(status: 200, body: '{"features": []}', headers: {"Content-Type" => "application/json"})
  end

  it "displays the list of tidal stations" do
    visit stations_path
    within "h1" do
      expect(page).to have_content("Stations")
    end
  end
end

