class RechargeLogsController < ApplicationController
  before_action :set_recharge_log, only: %i[ show update destroy ]

  # GET /recharge_logs
  def index
    @recharge_logs = RechargeLog.all

    render json: @recharge_logs
  end

  # GET /recharge_logs/1
  def show
    render json: @recharge_log
  end

  # POST /recharge_logs
  def create
    @recharge_log = RechargeLog.new(recharge_log_params)

    if @recharge_log.save
      render json: @recharge_log, status: :created, location: @recharge_log
    else
      render json: @recharge_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recharge_logs/1
  def update
    if @recharge_log.update(recharge_log_params)
      render json: @recharge_log
    else
      render json: @recharge_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recharge_logs/1
  def destroy
    @recharge_log.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recharge_log
      @recharge_log = RechargeLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recharge_log_params
      params.require(:recharge_log).permit(:user_id, :date, :exercise, :completed, :note)
    end
end
