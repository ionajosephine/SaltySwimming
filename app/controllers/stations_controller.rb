class StationsController < ApplicationController 

  def index 
    @stations = TideServices::Stations.new.call.body
  end
end