
class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_spots

  def index
    @spots = @spots.decorate
  end

  def show
    @spot = @spots.find(params[:id]).decorate
    @weather = WeatherServices::Daily.new.call(@spot.latitude, @spot.longitude).body
    @daily_weather = @weather["features"].first["properties"]
    @time_series = @weather["features"].first["properties"]["timeSeries"]
  end

  def new
    @spot = @spots.new
  end

  def create
    @spot = @spots.new(spot_params)

    if @spot.save
      redirect_to @spot
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @spot = @spots.find(params[:id])
  end

  def update
    @spot = @spots.find(params[:id])

    if @spot.update(spot_params)
      redirect_to @spot
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spot = @spots.find(params[:id])
    @spot.destroy

    redirect_to spots_path, status: :see_other
  end

  private

    def spot_params
      params.require(:spot).permit(:name, :latitude, :longitude, :condition, :notes)
    end

    def load_spots
      @spots = current_user.spots.order("LOWER(name) ASC")
    end
end