class StationsController < ApplicationController 

  def index 
    @stations = Station.all
  end

  def show
    @station = Station.find(params[:id])
    @tides = TideServices::Tides.new(@station.admiralty_id).call
  end
end