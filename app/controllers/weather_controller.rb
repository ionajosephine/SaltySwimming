class WeatherController < ApplicationController 
  def index 
    latitude = 50.186014
    longitude = -5.423444
    @dailylula = WeatherServices::Daily.new.call(latitude, longitude)
  end
end