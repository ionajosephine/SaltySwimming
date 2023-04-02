class SwimLogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @swim_logs = SwimLog.all
  end

  def show
    @swim_log = SwimLog.find(params[:id])
  end

  def new
    @swim_log = SwimLog.new
    @spots = current_user.spots
  end

  def create
    @swim_log = current_user.swim_logs.new(swim_log_params)

    if @swim_log.save
      redirect_to @swim_log
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @swim_log = SwimLog.find(params[:id])
  end

  def update
    @swim_log = SwimLog.find(params[:id])

    if @swim_log.update(swim_log_params)
      redirect_to @swim_log
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @swim_log = SwimLog.find(params[:id])
    @swim_log.destroy

    redirect_to swim_log_path, status: :see_other
  end

  private

    def swim_log_params
      params.require(:swim_log).permit(:user_id, :spot_id, :swim_date, :swim_time, :notes)
    end

end