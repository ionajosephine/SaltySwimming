require 'rails_helper'

RSpec.describe Tide do
  it "saves attributes on initialization" do
    tide = ::Tide.new(
      event: "HighTide", 
      date_time: "2023-03-05T11:28:00", 
      height: 0.7
    )
    expect(tide.event).to eq("HighTide")
    expect(tide.date_time).to eq("2023-03-05T11:28:00")
    expect(tide.height).to eq(0.7)
  end
end

