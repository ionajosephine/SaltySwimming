class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_spots

  def index
  end

  def show
    @spot = @spots.find(params[:id])
    if @station = Station.find_by(id: @spot.station_id)
      @tides = TideServices::Tides.new(@station.admiralty_id).call
    end
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
      params.require(:spot).permit(:name, :latitude, :longitude, :condition)
    end

    def load_spots
      @spots = current_user.spots
    end
end