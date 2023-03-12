class SpotsController < ApplicationController
  before_action :authenticate_user!

  def index
   @spots = Spot.all
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.user = current_user

    if @spot.save
      redirect_to @spot
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    @spot.user = current_user

    if @spot.update(spot_params)
      redirect_to @spot
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy

    redirect_to spots_path, status: :see_other
  end

  private

    def spot_params
      params.require(:spot).permit(:name, :latitude, :longitude, :user_id)
    end
end