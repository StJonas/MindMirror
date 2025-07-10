class EmotionLogsController < ApplicationController
  before_action :set_emotion_log, only: %i[ show update destroy ]

  # GET /emotion_logs
  def index
    @emotion_logs = EmotionLog.all

    render json: @emotion_logs
  end

  # GET /emotion_logs/1
  def show
    render json: @emotion_log
  end

  # POST /emotion_logs
  def create
    @emotion_log = EmotionLog.new(emotion_log_params)

    if @emotion_log.save
      render json: @emotion_log, status: :created, location: @emotion_log
    else
      render json: @emotion_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emotion_logs/1
  def update
    if @emotion_log.update(emotion_log_params)
      render json: @emotion_log
    else
      render json: @emotion_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emotion_logs/1
  def destroy
    @emotion_log.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emotion_log
      @emotion_log = EmotionLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def emotion_log_params
      params.require(:emotion_log).permit(:user_id, :date)
    end
end
