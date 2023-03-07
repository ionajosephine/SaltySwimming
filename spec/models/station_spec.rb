require 'rails_helper'

RSpec.describe Station do
  it "saves attributes on initialization" do
    station = Station.new(id: 123, name: "Truro", location: [1, 2])
    expect(station.id).to eq(123)
    expect(station.name).to eq("Truro")
    expect(station.location).to eq([1, 2])
  end
end