
class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_spots

  def index
    @spots = @spots.decorate
    @time_series = create_time_series(@spots)
  end

  # My original code:
  # def show
  #   @spot = @spots.find(params[:id]).decorate
  #   @weather = WeatherServices::Daily.new.call(@spot.latitude, @spot.longitude).body
  #   @daily_weather = @weather["features"].first["properties"]
  #   @time_series = @weather["features"].first["properties"]["timeSeries"]
  # end

  #Attempting to account for if the API doesn't return what we expect but needs improvement...:
  def show
    @spot = @spots.find(params[:id]).decorate
    @weather = WeatherServices::Daily.new.call(@spot.latitude, @spot.longitude).body
  
    if @weather && @weather["features"].is_a?(Array) && @weather["features"].first && @weather["features"].first["properties"]
      @daily_weather = @weather["features"].first["properties"]
      @time_series = @daily_weather["timeSeries"]
    else
    []
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
      params.require(:spot).permit(:name, :latitude, :longitude, :condition, :notes)
    end

    def load_spots
      @spots = current_user.spots.order("LOWER(name) ASC")
    end

    def plural_weather(spots)
      result = {}
      time_series.each do |day|
        result[day["time"].to_date] = {
          max_temp: day["dayMaxScreenTemperature"].round,
          lowest_feels: day["dayLowerBoundMaxFeelsLikeTemp"].round,
          highest_feels: day["dayUpperBoundMaxFeelsLikeTemp"].round,
          summary_emoji: emoji_summary(day["daySignificantWeatherCode"])
        }
      end
      result
    end

    # def create_time_series(spots)
    #   result = {}
    #   spots.each do |spot|
    #     result[spot.id] = WeatherServices::Daily.new.call(spot.latitude, spot.longitude).body["features"].first["properties"]["timeSeries"]
    #   end
    #   result
    # end

    def create_time_series(spots)
      result = {}
      spots.each do |spot|
        response = WeatherServices::Daily.new.call(spot.latitude, spot.longitude).body
        if response && response["features"] && response["features"].first && response["features"].first["properties"]
          time_series = response["features"].first["properties"]["timeSeries"]
          result[spot.id] = time_series if time_series
        else
          result[spot.id] = [] # Empty array as fallback value
        end
      end
      result
    end
    
    

end