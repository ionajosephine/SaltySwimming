class StationsController < ApplicationController 

  def index 
    @stations = TideServices::Stations.new.call.body
  end

  def show
    @station = TideServices::Station.new(params[:id]).call.body
  end
end