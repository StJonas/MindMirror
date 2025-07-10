class EmotionLogEntriesController < ApplicationController
  before_action :set_emotion_log_entry, only: %i[ show update destroy ]

  # GET /emotion_log_entries
  def index
    @emotion_log_entries = EmotionLogEntry.all

    render json: @emotion_log_entries
  end

  # GET /emotion_log_entries/1
  def show
    render json: @emotion_log_entry
  end

  # POST /emotion_log_entries
  def create
    @emotion_log_entry = EmotionLogEntry.new(emotion_log_entry_params)

    if @emotion_log_entry.save
      render json: @emotion_log_entry, status: :created, location: @emotion_log_entry
    else
      render json: @emotion_log_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emotion_log_entries/1
  def update
    if @emotion_log_entry.update(emotion_log_entry_params)
      render json: @emotion_log_entry
    else
      render json: @emotion_log_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emotion_log_entries/1
  def destroy
    @emotion_log_entry.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emotion_log_entry
      @emotion_log_entry = EmotionLogEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def emotion_log_entry_params
      params.require(:emotion_log_entry).permit(:emotion_log_id, :emotion_id, :note)
    end
end
