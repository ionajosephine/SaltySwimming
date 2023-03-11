class StationsController < ApplicationController 

  def index 
    @stations = TideServices::Stations.new.call
  end

  def show
    @station = TideServices::Station.new(params[:id]).call
    @tides = TideServices::Tides.new(params[:id]).call
  end
end